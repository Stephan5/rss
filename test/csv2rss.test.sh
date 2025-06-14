#!/bin/bash
set -Eeuo pipefail

cleanup() {
  rm -rf "$TEST_DIR"
  rm -rf "$TEST_FEED_DIR"
}

# Paths
TEST_DIR=$(mktemp -d)

BASE_DIR="$(dirname "$0")/.."
BASE_DIR_ABS="$(cd "$BASE_DIR" && pwd)"
SCRIPT="$BASE_DIR_ABS/script/csv2rss.sh"
TEST_FEED_DIR="$BASE_DIR_ABS/feed/test"
INPUT_CSV="$TEST_FEED_DIR/test.csv"
EXPECTED="$TEST_DIR/expected.xml"
ACTUAL="$BASE_DIR_ABS/feed/test/test.xml"

# Create test feed directory
mkdir -p "$TEST_FEED_DIR"

# Clean up on exit
trap cleanup EXIT

cat > "$INPUT_CSV" <<EOF
titledescriptiondateurl
2002-06-29Sat, 29 Jun 2002 03:00:00 GMThttps://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_100KB_MP3.mp3?id=1
S01E01&lt;p&gt;You're the one that's sad and lonely!&lt;/p&gt;Sun, 30 June 2002 19:07:00 +0100https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_100KB_MP3.mp3?id=2
Ep. 1 - The Original Cum Boys&lt;a href="http://shoutengine.com/CumTown/ep-1-the-original-cum-boys-19282" rel="nofollow noopener" target="_blank"&gt;May 11, 2016&lt;/a&gt; &lt;p&gt;Cum Boys NYC Originals Nick and Stav sit down and start a podcast. This one is different than other podcasts where two guys talk about people you don't know. We get real dude. We take this shit seriously. &lt;/p&gt;&lt;p&gt;&lt;strong&gt;Tags&lt;/strong&gt;&lt;/p&gt;&lt;ul&gt; &lt;li&gt;&lt;a href="http://shoutengine.com/tags/vaping/" rel="nofollow noopener" target="_blank"&gt;vaping&lt;/a&gt;&lt;/li&gt; &lt;li&gt;&lt;a href="http://shoutengine.com/tags/420/" rel="nofollow noopener" target="_blank"&gt;420&lt;/a&gt;&lt;/li&gt; &lt;li&gt;&lt;a href="http://shoutengine.com/tags/storytelling/" rel="nofollow noopener" target="_blank"&gt;storytelling&lt;/a&gt;&lt;/li&gt; &lt;li&gt;&lt;a href="http://shoutengine.com/tags/professional-comedians/" rel="nofollow noopener" target="_blank"&gt;professional comedians&lt;/a&gt;&lt;/li&gt; &lt;li&gt;&lt;a href="http://shoutengine.com/tags/politics/" rel="nofollow noopener" target="_blank"&gt;politics&lt;/a&gt;&lt;/li&gt;&lt;/ul&gt;Mon, 01 July 2002 20:33:05 GMThttps://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_100KB_MP3.mp3?id=3
Inaugral BusinessTue, 02 July 2002 03:00:00 GMThttps://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_100KB_MP3.mp3?id=4
Mince 1: The Power of Gentleness&lt;p&gt;Gentle managers, unofficial tractors, cheap lobster and black dogs are covered in the first episode of this football podcast with Bob Mortimer and Andy Dawson.&lt;/p&gt;Wed, 03 July 2002 18:50:00 GMThttps://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_100KB_MP3.mp3?id=5
2006 01 03 - TuesdayThu, 04 July 2002 03:00:00 GMThttps://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_100KB_MP3.mp3?id=6
EOF

# Run your script (customize flags as needed)
"$SCRIPT" "$INPUT_CSV" --delimiter $'\x1F' \
                       --title "Dudes Rock" \
                       --description "Hell yeah dude!" \
                       --author "Real-ass dudes" \
                       --image-url "https://link.com/image.jpg"

echo
echo


cat > "$EXPECTED" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<rss xmlns:atom="http://www.w3.org/2005/Atom" xmlns:content="http://purl.org/rss/1.0/modules/content/" xmlns:wfw="http://wellformedweb.org/CommentAPI/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" xmlns:googleplay="http://www.google.com/schemas/play-podcasts/1.0" xmlns:spotify="http://www.spotify.com/ns/rss" xmlns:podcast="https://podcastindex.org/namespace/1.0" xmlns:media="http://search.yahoo.com/mrss/" version="2.0">
  <channel>
    <atom:link href="https://raw.githubusercontent.com/Stephan5/podcasts/refs/heads/main/feed/test/test.xml" rel="self" type="application/rss+xml"/>
    <title>Dudes Rock</title>
    <description>&lt;p&gt;Hell yeah dude! &lt;/p&gt;&lt;br/&gt;&lt;p&gt;Generated using Stephan5/podcasts.&lt;/p&gt;</description>
    <itunes:author>Real-ass dudes</itunes:author>
    <language>en-gb</language>
    <copyright>none</copyright>
    <link>https://github.com/Stephan5/podcasts/tree/main/feed/test</link>
    <image>
      <url>https://link.com/image.jpg</url>
      <title>Dudes Rock</title>
      <link>https://github.com/Stephan5/podcasts/tree/main/feed/test</link>
    </image>
    <generator>Stephan5/podcasts</generator>
    <lastBuildDate>Tue, 20 May 2025 22:05:59 +0100</lastBuildDate>
    <pubDate>Tue, 20 May 2025 22:05:59 +0100</pubDate>
    <item>
      <link>https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_100KB_MP3.mp3?id=1</link>
      <guid>https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_100KB_MP3.mp3?id=1</guid>
      <title>1: 2002-06-29</title>
      <description>2002-06-29 - Episode 1 of Dudes Rock&lt;br/&gt;&lt;br/&gt;&lt;a href="https://github.com/Stephan5/podcasts" rel="nofollow noopener" target="_blank"&gt;Generated using Stephan5/podcasts&lt;/a&gt;</description>
      <pubDate>Sat, 29 Jun 2002 03:00:00 GMT</pubDate>
      <enclosure url="https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_100KB_MP3.mp3?id=1" length="103016" type="audio/mpeg"/>
    </item>
    <item>
      <link>https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_100KB_MP3.mp3?id=2</link>
      <guid>https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_100KB_MP3.mp3?id=2</guid>
      <title>2: S01E01</title>
      <description>&lt;p&gt;You're the one that's sad and lonely!&lt;/p&gt;&lt;br/&gt;&lt;br/&gt;&lt;a href="https://github.com/Stephan5/podcasts" rel="nofollow noopener" target="_blank"&gt;Generated using Stephan5/podcasts&lt;/a&gt;</description>
      <pubDate>Sun, 30 June 2002 19:07:00 +0100</pubDate>
      <enclosure url="https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_100KB_MP3.mp3?id=2" length="103016" type="audio/mpeg"/>
    </item>
    <item>
      <link>https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_100KB_MP3.mp3?id=3</link>
      <guid>https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_100KB_MP3.mp3?id=3</guid>
      <title>3: Ep. 1 - The Original Cum Boys</title>
      <description>&lt;a href="http://shoutengine.com/CumTown/ep-1-the-original-cum-boys-19282" rel="nofollow noopener" target="_blank"&gt;May 11, 2016&lt;/a&gt; &lt;p&gt;Cum Boys NYC Originals Nick and Stav sit down and start a podcast. This one is different than other podcasts where two guys talk about people you don't know. We get real dude. We take this shit seriously. &lt;/p&gt;&lt;p&gt;&lt;strong&gt;Tags&lt;/strong&gt;&lt;/p&gt;&lt;ul&gt; &lt;li&gt;&lt;a href="http://shoutengine.com/tags/vaping/" rel="nofollow noopener" target="_blank"&gt;vaping&lt;/a&gt;&lt;/li&gt; &lt;li&gt;&lt;a href="http://shoutengine.com/tags/420/" rel="nofollow noopener" target="_blank"&gt;420&lt;/a&gt;&lt;/li&gt; &lt;li&gt;&lt;a href="http://shoutengine.com/tags/storytelling/" rel="nofollow noopener" target="_blank"&gt;storytelling&lt;/a&gt;&lt;/li&gt; &lt;li&gt;&lt;a href="http://shoutengine.com/tags/professional-comedians/" rel="nofollow noopener" target="_blank"&gt;professional comedians&lt;/a&gt;&lt;/li&gt; &lt;li&gt;&lt;a href="http://shoutengine.com/tags/politics/" rel="nofollow noopener" target="_blank"&gt;politics&lt;/a&gt;&lt;/li&gt;&lt;/ul&gt;&lt;br/&gt;&lt;br/&gt;&lt;a href="https://github.com/Stephan5/podcasts" rel="nofollow noopener" target="_blank"&gt;Generated using Stephan5/podcasts&lt;/a&gt;</description>
      <pubDate>Mon, 01 July 2002 20:33:05 GMT</pubDate>
      <enclosure url="https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_100KB_MP3.mp3?id=3" length="103016" type="audio/mpeg"/>
    </item>
    <item>
      <link>https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_100KB_MP3.mp3?id=4</link>
      <guid>https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_100KB_MP3.mp3?id=4</guid>
      <title>4: Inaugral Business</title>
      <description>Inaugral Business - Episode 4 of Dudes Rock&lt;br/&gt;&lt;br/&gt;&lt;a href="https://github.com/Stephan5/podcasts" rel="nofollow noopener" target="_blank"&gt;Generated using Stephan5/podcasts&lt;/a&gt;</description>
      <pubDate>Tue, 02 July 2002 03:00:00 GMT</pubDate>
      <enclosure url="https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_100KB_MP3.mp3?id=4" length="103016" type="audio/mpeg"/>
    </item>
    <item>
      <link>https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_100KB_MP3.mp3?id=5</link>
      <guid>https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_100KB_MP3.mp3?id=5</guid>
      <title>5: Mince 1: The Power of Gentleness</title>
      <description>&lt;p&gt;Gentle managers, unofficial tractors, cheap lobster and black dogs are covered in the first episode of this football podcast with Bob Mortimer and Andy Dawson.&lt;/p&gt;&lt;br/&gt;&lt;br/&gt;&lt;a href="https://github.com/Stephan5/podcasts" rel="nofollow noopener" target="_blank"&gt;Generated using Stephan5/podcasts&lt;/a&gt;</description>
      <pubDate>Wed, 03 July 2002 18:50:00 GMT</pubDate>
      <enclosure url="https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_100KB_MP3.mp3?id=5" length="103016" type="audio/mpeg"/>
    </item>
    <item>
      <link>https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_100KB_MP3.mp3?id=6</link>
      <guid>https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_100KB_MP3.mp3?id=6</guid>
      <title>6: 2006 01 03 - Tuesday</title>
      <description>2006 01 03 - Tuesday - Episode 6 of Dudes Rock&lt;br/&gt;&lt;br/&gt;&lt;a href="https://github.com/Stephan5/podcasts" rel="nofollow noopener" target="_blank"&gt;Generated using Stephan5/podcasts&lt;/a&gt;</description>
      <pubDate>Thu, 04 July 2002 03:00:00 GMT</pubDate>
      <enclosure url="https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_100KB_MP3.mp3?id=6" length="103016" type="audio/mpeg"/>
    </item>
  </channel>
</rss>
EOF

# Extract and check <lastBuildDate>
last_build_date=$(grep -m1 '<lastBuildDate>' "$ACTUAL" | sed -E 's/.*<lastBuildDate>(.*)<\/lastBuildDate>.*/\1/')
if [[ ! "$last_build_date" =~ ^[A-Z][a-z]{2},\ [0-9]{2}\ [A-Z][a-z]{2}\ [0-9]{4}\ [0-9]{2}:[0-9]{2}:[0-9]{2}\ [+-][0-9]{4}$ ]]; then
  echo "❌ TEST FAIL: <lastBuildDate> is missing or malformed: $last_build_date"
  exit 1
fi

# Extract and check channel-level <pubDate>
channel_pub_date=$(grep -m1 '<pubDate>' "$ACTUAL" | sed -E 's/.*<pubDate>(.*)<\/pubDate>.*/\1/')
if [[ ! "$channel_pub_date" =~ ^[A-Z][a-z]{2},\ [0-9]{2}\ [A-Z][a-z]{2}\ [0-9]{4}\ [0-9]{2}:[0-9]{2}:[0-9]{2}\ [+-][0-9]{4}$ ]]; then
  echo "❌ TEST FAIL: channel <pubDate> is missing or malformed: $channel_pub_date"
  exit 1
fi

# Compare output
if diff -u \
     <(awk '/<lastBuildDate>/ {next} /<pubDate>/ && !seen++ {next} 1' "$EXPECTED") \
     <(awk '/<lastBuildDate>/ {next} /<pubDate>/ && !seen++ {next} 1' "$ACTUAL"); then
  echo "✅ TEST PASS: Output matches expected."
else
  echo "❌ TEST FAIL: Output does not match expected."
  exit 1
fi
