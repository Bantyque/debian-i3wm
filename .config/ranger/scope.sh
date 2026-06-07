#!/usr/bin/env bash
# ===================================================================
# scope.sh — скрипт предпросмотра для ranger
# Зависимости: ueberzug, ffmpegthumbnailer, highlight, atool, w3m
# ===================================================================

set -o noclobber -o noglob -o nounset -o pipefail
IFS=$'\n'

# Аргументы от ranger
FILE_PATH="${1}"
PV_WIDTH="${2}"
PV_HEIGHT="${3}"
IMAGE_CACHE_PATH="${4}"
PV_IMAGE_ENABLED="${5}"

FILE_EXTENSION="${FILE_PATH##*.}"
FILE_EXTENSION_LOWER="$(printf "%s" "${FILE_EXTENSION}" | tr '[:upper:]' '[:lower:]')"

# Выход с кодами:
# 0 — успешно показано
# 1 — не удалось, показать как текст
# 2 — не удалось, нет предпросмотра
# 3 — успешно, картинка в IMAGE_CACHE_PATH
# 4 — успешно, картинка это FILE_PATH

handle_image() {
    local mimetype="${1}"
    case "${mimetype}" in
        image/svg+xml|image/svg)
            convert -- "${FILE_PATH}" "${IMAGE_CACHE_PATH}" && exit 3
            exit 1;;

        image/*)
            exit 4;;

        video/*)
            # Превью первого кадра видео
            ffmpegthumbnailer -i "${FILE_PATH}" -o "${IMAGE_CACHE_PATH}" -s 0 \
                && exit 3
            exit 1;;

        application/pdf)
            pdftoppm -f 1 -l 1 \
                -scale-to-x "${PV_WIDTH}" \
                -scale-to-y -1 \
                -singlefile \
                -jpeg \
                -- "${FILE_PATH}" "${IMAGE_CACHE_PATH%.*}" \
                && exit 3 || exit 1;;
    esac
}

handle_extension() {
    case "${FILE_EXTENSION_LOWER}" in
        # Архивы
        a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|\
        rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)
            atool --list -- "${FILE_PATH}" && exit 5
            bsdtar --list --file "${FILE_PATH}" && exit 5
            exit 1;;

        rar)
            unrar lt -p- -- "${FILE_PATH}" && exit 5
            exit 1;;

        7z)
            7z l -- "${FILE_PATH}" && exit 5
            exit 1;;

        # PDF текстом
        pdf)
            pdftotext -l 10 -nopgbrk -q -- "${FILE_PATH}" - && exit 5
            exiftool "${FILE_PATH}" && exit 5
            exit 1;;

        # Торрент
        torrent)
            transmission-show -- "${FILE_PATH}" && exit 5
            exit 1;;

        # OpenDocument
        odt|ods|odp|sxw)
            odt2txt "${FILE_PATH}" && exit 5
            exit 1;;

        # Медиа инфо
        mp3|mp4|mkv|avi|mov|flac|wav|ogg|m4a|webm)
            mediainfo "${FILE_PATH}" && exit 5
            exit 1;;
    esac
}

handle_mime() {
    local mimetype="${1}"
    case "${mimetype}" in
        # Подсветка кода через highlight
        text/* | */xml)
            highlight \
                --out-format=ansi \
                --force \
                --style=pablo \
                -- "${FILE_PATH}" && exit 5
            exit 2;;

        # JSON
        application/json)
            python3 -m json.tool -- "${FILE_PATH}" && exit 5
            exit 2;;
    esac
}

handle_fallback() {
    echo '----- File Type Classification -----' && file --dereference --brief -- "${FILE_PATH}" && exit 5
    exit 1
}

MIMETYPE="$(file --dereference --brief --mime-type -- "${FILE_PATH}")"

if [[ "${PV_IMAGE_ENABLED}" == 'True' ]]; then
    handle_image "${MIMETYPE}"
fi

handle_extension
handle_mime "${MIMETYPE}"
handle_fallback

exit 1
