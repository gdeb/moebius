# Moebius

This is an experiment in SSPA (Single Static Page Application).  I have no idea
if the term SSPA actually exists, but it describes quite well the idea: the
application is completely static, but the client code is a SPA, which does routing
and all that stuff.


## Prerequisites

- [Node](http://nodejs.org) (best to install with [Homebrew](http://brew.sh))
- [Elm](http://elm-lang.org/install)
- [Brunch](http://brunch.io)

## Install

```
elm package install
npm install
```

## Run

`brunch watch --server`

## Notes

Interesting technical informations on this:
- responsive without a single mediaquery (nor any css framework)
- fully static, but with client side routing
- no server side routing
- completely generated programatically

Fully static means that there are no rpc whatsoever.  This is of course only
possible with the full content in each files.  Possible because the size of this
website is quite small, especially gzipped.

Advantages:
- very simple to deploy, any static server will do
- allow transitions between pages

Nice to have:
- typesafe routing (as in, statically checked, and guaranteed to be defined)
