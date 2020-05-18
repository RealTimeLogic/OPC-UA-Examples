outdir=bin
dist:
	rm -rf ${outdir}
	mkdir -p ${outdir} ${outdir}/doc/dev_guide/en
	cd mako_zip && (find -L | zip -@ -x . .. @ ../${outdir}/mako) && cd ..
	cd uaserver_zip && (find -L | zip -@ -x . .. @ ../${outdir}/uaserver) && cd ..
	cp mako mako.exe mako.conf ${outdir}
	cp -r opcua-lua.git/doc/build/en/html ${outdir}/doc/dev_guide/en/html
	cp -r opcua-lua.git/doc/build/en/singlehtml ${outdir}/doc/dev_guide/en/singlehtml
	cp opcua-lua.git/doc/user_guide.docx ${outdir}/doc/user_guide.docx
	cp opcua-lua.git/doc/user_guide.odt ${outdir}/doc/user_guide.odt
	if [ -f mako_opcua_server.zip ] ; then  rm mako_opcua_server.zip ; fi
	cd ${outdir} && zip -r ../mako_opcua_server.zip mako.conf mako mako.exe mako.zip uaserver.zip doc && cd ..


distclean: clean
	if [ -f mako_opcua_server.zip ] ; then  rm mako_opcua_server.zip ; fi

clean:
	if [ -d ${outdir} ] ; then rm -r ${outdir} ; fi
