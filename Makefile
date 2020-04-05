outdir=bin
dist:
	rm -rf ${outdir}
	mkdir ${outdir}
	cd mako_zip && (find -L | zip -@ -x . .. @ ../${outdir}/mako) && cd ..
	cd uaserver_zip && (find -L | zip -@ -x . .. @ ../${outdir}/uaserver) && cd ..
	cp mako mako.exe mako.conf ${outdir}
	cd ${outdir} && zip ../mako_opcua_server.zip mako.conf mako mako.exe mako.zip uaserver.zip && cd ..

