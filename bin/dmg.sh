#!/bin/zsh

OUTDIR=${OUTDIR:-}
ENCRYPT_METHOD=${ENCRYPT_METHOD:-AES-128}
PASSWORD_FILE=${PASSWORD_FILE:-$HOME/.dmg-password}

TIMESTAMP=${TIMESTAMP:-no}
TIMESTAMP_FORMAT="%Y-%m-%d"

_hdiutil() {
    hdiutil $* || exit 1
}

_hdiutil_create() {
    local format="$1"
    local volname="${2:-noname}"
    local srcfolder="$3"
    local outfile="$4"

    local format_name="read-only"
    local password_file=${PASSWORD_FILE:-$HOME/.password.key}
    local encrypt_method=${ENCRYPT_METHOD}
    local is_encrypted=0

    case "$format" in
        UDRO|RO)
            format_name="read-only"
            format="UDRO"
        ;;
        UDZO|ZIP)
            format_name="compressed"
            format="UDZO"
        ;;
        ENC)
            is_encrypted=1
            format_name="encrypted+compressed"
            format="UDZO"
            case "$encrypt_method" in
                AES-128|AES-256) ;;
                *)
                    echo "ERROR: Unknown encrypt method: '$encrypt_method'"
                    exit 1
                ;;
            esac
            test -f "$password_file" || {
                echo "ERROR: Password file is not found: '$password_file'"
                exit 1
            }
        ;;
        *)
            echo "ERROR: Unknown format '$format'"
            exit 1
        ;;
    esac

    case "$TIMESTAMP" in
        yes|1)
            local v="$(date +${TIMESTAMP_FORMAT})"
            test -z "$v" || volname="${volname} (${v})"
        ;;
    esac

    test -d "$srcfolder" || {
        echo "ERROR: Directory not found: '$srcfolder'"
        exit 1
    }

    test -z "$outfile" && {
        echo "ERROR: Outfile is empty"
        exit 1
    }

    test -d "$outfile" && {
        echo "ERROR: Out path is directory: '$outfile'"
        exit 1
    }

    test -f "$outfile" && {
        echo "ERROR: Outfile is exist: '$outfile'"
        exit 1
    }

    local tmp_filename="$(basename "$outfile")"
    [[ "${tmp_filename:0:1}" == "." ]] && {
        local tmp_dirname="$(dirname "$outfile")"
        outfile="${tmp_dirname}/${tmp_filename:1}"
    }
    [[ "${volname:0:1}" == "." ]] && {
        volname="${volname:1}"
    }

    echo "* Creating ${format_name} dmg-container '${outfile}' from '${srcfolder}' ..."

    # find "$srcfolder" -type f -iname ".ds_store" -delete || exit 1

    if [[ "$is_encrypted" == "1" ]] ; then
        echo -n "$(cat "$password_file")" | _hdiutil create \
            -volname "${volname}" \
            -fs HFS+ \
            -nospotlight \
            -format "${format}" \
            -srcfolder "${srcfolder}" \
            -encryption $encrypt_method \
            -stdinpass \
            "$outfile"
    else  # not encrypted
        _hdiutil create \
            -fs HFS+ \
            -nospotlight \
            -format "${format}" \
            -volname "${volname}" \
            -srcfolder "${srcfolder}" \
            "$outfile"
    fi
}

_hdiutil_create_many() {
    local format="$1"
    shift

    argc=$#
    for i in $(seq $#) ; do
        local outdir="${OUTDIR}"
        inpath="$1"

        test -d "$inpath" || {
            echo "SKIP: path is not directory or not exist: $inpath"
            continue
        }

        test -z "$outdir" && {
            tmp="$(dirname "$inpath")"
            outdir="${tmp:-.}"
        }

        local name="$(basename "$inpath")"
        local outfile="$outdir/$name"

        echo "[$i/$argc]"
        _hdiutil_create $format "$name" "$inpath" "$outfile.dmg"
        shift
    done
}

case "$1" in
    ro)
        shift
        _hdiutil_create_many "RO" $*
    ;;
    zip)
        shift
        _hdiutil_create_many "ZIP" $*
    ;;
    encrypt)
        shift
        _hdiutil_create_many "ENC" $*
    ;;
    *)
        echo "Usage: $(basename "$0") <options> [directories...]"
        echo
        echo "Options:"
        echo "  ro       - creates an read-only dmg-container"
        echo "  zip      - creates an compressed dmg-container"
        echo "  encrypt  - creates an encrypted dmg-container (for password using env PASSWORD_FILE)"
        echo
        echo "Environments:"
        echo "  OUTDIR         - output directory for dmg-containers (default: '$OUTDIR')"
        echo "  PASSWORD_FILE  - password file for encrypted dmg-container (default: '$PASSWORD_FILE')"
        echo "  ENCRYPT_METHOD - AES-128 or AES-256 (default: '$ENCRYPT_METHOD')"
        echo "  TIMESTAMP      - if not empty value, then add timestamp to volume name"
        echo
        exit 1
esac

exit 0

