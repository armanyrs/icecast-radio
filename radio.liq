log.file.path := "/tmp/radio.log"
log.stdout := true

# Enable telnet + harbor web control
settings.server.telnet := true
settings.server.telnet.port := 1234

server.harbor(port=8001)
interactive.harbor(port=8002)

# Mic + Playlist sources
mic = input.alsa(device="hw:0,6", bufferize=false, fallible=true)
playlist_tracks = playlist("/home/armanyrs/Music/playlist", reload_mode="watch")
jingle = single("/home/armanyrs/Music/jingle.mp3")

# Fungsi untuk memproses metadata
def metadata_processor(m) =
  # Ambil judul dari metadata file atau beri default
  title = m["title"] ?? "Unknown Title"
  artist = m["artist"] ?? "Unknown Artist"
  
  # Format metadata untuk Icecast
  [("title", "#{artist} - #{title} | TRM FM")]
end

# Terapkan metadata processing
playlist_with_metadata = metadata.map(metadata_processor, playlist_tracks)

# Gabungkan playlist + jingle
playlist_with_jingle = random(weights=[1,5], [jingle, playlist_with_metadata])
safe_playlist = mksafe(playlist_with_jingle)

# Interactive boolean untuk on/off mic
mic_on = interactive.bool("mic_on", false)

# Insert metadata node untuk microphone
mic = server.insert_metadata(id="mic_meta", mic)

# Switch antar mic & playlist
radio = switch(
  track_sensitive=false,
  [(mic_on, mic), ({true}, safe_playlist)]
)

# Output ke Icecast dengan metadata default
output.icecast(
  %mp3,
  host="192.168.1.2", 
  port=8000, 
  password="123456", 
  mount="/radio",
  description="TRM FM Radio Streaming",
  genre="Various",
  radio
)
