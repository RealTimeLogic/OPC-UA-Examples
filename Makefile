outdir=bin
dist:
	rm -rf ${outdir}
	mkdir -p ${outdir} ${outdir}/doc/en ${outdir}/doc/ru
	cd uaserver_zip && (find -L | zip -@ -x . .. @ ../${outdir}/uaserver) && cd ..
	cp mako mako.zip mako.exe mako.conf ${outdir}
	cp -r opcua-lua.git/doc/build/en/html ${outdir}/doc/en/html
	cp -r opcua-lua.git/doc/build/en/singlehtml ${outdir}/doc/en/singlehtml
	cp -r opcua-lua.git/doc/build/ru/html ${outdir}/doc/ru/html
	cp -r opcua-lua.git/doc/build/ru/singlehtml ${outdir}/doc/ru/singlehtml
	if [ -f mako_opcua_server.zip ] ; then  rm mako_opcua_server.zip ; fi
	cd ${outdir} && zip -r ../mako_opcua_server.zip mako.conf mako mako.exe mako.zip uaserver.zip doc && cd ..


distclean: clean
	if [ -f mako_opcua_server.zip ] ; then  rm mako_opcua_server.zip ; fi

clean:
	if [ -d ${outdir} ] ; then rm -r ${outdir} ; fi
