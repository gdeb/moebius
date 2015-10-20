
clean:
	rm -rf public/

prod: clean
	brunch build -P
	sed -i '' 's/Display.FULLSCREEN, container/Display.FULLSCREEN, document.body/g' public/main.js
	uglifyjs public/main.js --screw-ie8 --mangle --compress > public/temp1.js
	java -jar node_modules/google-closure-compiler/compiler.jar --js public/temp1.js > public/temp2.js
	mv public/temp2.js public/main.js
	rm public/temp1.js
	cp public/index.html public/about.html
	cp public/index.html public/posts.html
	cp public/index.html public/projects.html

devserver: clean
	brunch watch --server
