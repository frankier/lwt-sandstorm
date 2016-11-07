.PHONY: all built-lwt clean built-lwt/.sandstorm

all: built-lwt

clean:
	rm -r built-lwt || true
	rm -r lwt || true

lwt/.git:
	git submodule update --init

built-lwt: built-lwt/index.php built-lwt/connect.inc.php built-lwt/.sandstorm

built-lwt/index.php: lwt/.git
	rm -r built-lwt || true
	cp -r lwt built-lwt
	rm -r built-lwt/.git
	#cd built-lwt && find . -type f -name "*.php" -exec sed -i 's/ target="_top"//g' {} +
	#cd built-lwt && find . -type f -name "*.php" -exec sed -i 's/top\.location/parent.location/g' {} +

built-lwt/connect.inc.php: built-lwt/index.php
	cp built-lwt/connect_xampp.inc.php built-lwt/connect.inc.php

built-lwt/.sandstorm: built-lwt/index.php build-lwt/.sandstorm/sandstorm-pkgdef.capnp built-lwt/.sandstorm/icons built-lwt/.sandstorm/UNLICENSE.txt built-lwt/.sandstorm/description.md built-lwt/.sandstorm/screens

build-lwt/.sandstorm/sandstorm-pkgdef.capnp: .sandstorm/sandstorm-pkgdef.capnp
	cp -r .sandstorm built-lwt

built-lwt/.sandstorm/UNLICENSE.txt: built-lwt/index.php built-lwt/.sandstorm/sandstorm-pkgdef.capnp
	cp built-lwt/UNLICENSE.txt built-lwt/.sandstorm/UNLICENSE.txt

built-lwt/.sandstorm/description.md: built-lwt/index.php
	pup ':parent-of(:parent-of([name=abstract])) + dd' < built-lwt/info.htm | \
	  pandoc -f html -t markdown_github | \
	  sed 's/(1)//' | \
	  sed -n '/(2)/q;p' > \
	  built-lwt/.sandstorm/description.md

built-lwt/.sandstorm/icons: built-lwt/index.php built-lwt/.sandstorm/sandstorm-pkgdef.capnp
	mkdir built-lwt/.sandstorm/icons/
	gm convert \
	   built-lwt/img/lwt_icon_big.png \
	  -background white \
	  -gravity center \
	  -extent 300x300 \
	   built-lwt/.sandstorm/icons/market-big-300x300.png
	gm convert \
	   built-lwt/img/lwt_icon_big.png \
	  -resize '175x175' \
	   built-lwt/.sandstorm/icons/market-150x150.png
	gm convert \
	   built-lwt/img/lwt_icon_big.png \
	  -resize '128x128' \
	   built-lwt/.sandstorm/icons/appgrid-128x128.png
	gm convert \
	   built-lwt/img/lwt_icon.png \
	  -resize '24x24' \
	   built-lwt/.sandstorm/icons/grain-24x24.png

built-lwt/.sandstorm/screens: built-lwt/index.php built-lwt/.sandstorm/sandstorm-pkgdef.capnp
	mkdir built-lwt/.sandstorm/screens
	cp built-lwt/img/04.jpg built-lwt/.sandstorm/screens/1.jpg
	cp built-lwt/img/12.jpg built-lwt/.sandstorm/screens/2.jpg
	cp built-lwt/img/22.jpg built-lwt/.sandstorm/screens/3.jpg
