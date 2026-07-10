function ytdlp
    set -l link $argv[1]
    if test -z "$link"
        echo "Немає посиланя"
        return 1
    end

    yt-dlp -f "ba" -x --audio-format mp3 --audio-quality 0 \
    --embed-metadata --embed-thumbnail \
    --download-archive "/home/trip/yt-dlp/archive.txt" \
    -P "/home/trip/yt-dlp/" \
    -o "%(artist)s - %(title)s.%(ext)s" \
    "$link"
end
