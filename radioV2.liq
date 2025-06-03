log.file.path := "/tmp/radio.log"
log.stdout := true

# Enable telnet + harbor web control
settings.server.telnet := true
settings.server.telnet.port := 1234

server.harbor(port=8001)
interactive.harbor(port=8002)

# Mic input
mic = input.alsa(device="hw:0,6", bufferize=false, fallible=true)

# Playlist pagi dan malam
playlist_pagi = playlist("/home/armanyrs/Music/playlist_pagi", reload_mode="watch")
playlist_malam = playlist("/home/armanyrs/Music/playlist_malam", reload_mode="watch")
jingle = single("/home/armanyrs/Music/jingle.mp3")

# Metadata processor
def metadata_processor(m) =
  title = m["title"] ?? "Unknown Title"
  artist = m["artist"] ?? "Unknown Artist"
  [("title", "#{artist} - #{title} | TRM FM")]
end

# Tambahkan metadata
playlist_pagi = metadata.map(metadata_processor, playlist_pagi)
playlist_malam = metadata.map(metadata_processor, playlist_malam)

# Tambahkan jingle
playlist_pagi = random(weights=[1,5], [jingle, playlist_pagi])
playlist_malam = random(weights=[1,5], [jingle, playlist_malam])

# Buat aman
playlist_pagi = mksafe(playlist_pagi)
playlist_malam = mksafe(playlist_malam)

# Switch playlist pagi/malam
use_malam_playlist = interactive.bool("use_malam_playlist", false)
playlist_selected = switch(
  track_sensitive=false,
  [ (use_malam_playlist, playlist_malam),
    ({true}, playlist_pagi) ]
)

# Switch mic / playlist
mic_on = interactive.bool("mic_on", false)
mic = server.insert_metadata(id="mic_meta", mic)

radio = switch(
  track_sensitive=false,
  [ (mic_on, mic),
    ({true}, playlist_selected) ]
)

# Output ke Icecast
output.icecast(
  %mp3,
  host="10.252.134.181",
  port=8000,
  password="123456",
  mount="/radio",
  description="TRM FM Radio Streaming",
  genre="Various",
  radio
)
