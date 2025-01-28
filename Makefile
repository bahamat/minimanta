.PHONY: all clean install

NODE_VER  = v10.24.1
NODE_EXEC = ./build/node/bin/node
NPM_EXEC  = ./build/node/bin/npm

all: node_modules smf.xml

$(NODE_EXEC):
	@printf 'Installing node...'
	@mkdir build || true
	@cd build ; curl -LO --progress-bar https://nodejs.org/dist/$(NODE_VER)/node-$(NODE_VER)-sunos-x64.tar.xz
	@cd build ; tar Jxf node-$(NODE_VER)-sunos-x64.tar.xz
	@mv build/node-v10.24.1-sunos-x64 build/node

node_modules: package.json $(NODE_EXEC)
	$(NPM_EXEC) install

smf.xml: smf-template.xml
	sed 's#__DIRECTORY__#$(PWD)#g' < $< > $@

install: smf.xml config.json
	svccfg import $<

config.json:
	@echo 'You must create config.json yourself. Use config.json.dist as an example.' ; exit 1

clean:
	rm -rf build node_modules smf.xml
