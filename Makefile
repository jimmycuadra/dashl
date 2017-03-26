build: elm-make elm-css

elm-make:
	elm make src/Main.elm --warn --output dist/js/main.js

elm-css:
	yarn run elm-css Stylesheets.elm
