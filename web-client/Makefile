ifndef BAROOT
$(error BAROOT must be defined in the environment)
endif
BAROOT := $(subst \,/,$(BAROOT))

ifeq ($(OS),Windows_NT)
export EXE=.exe
endif


outdir=bin

MAKO=${BAROOT}/examples/MakoServer/obj/release/mako${EXE}
MAKO_ZIP=${BAROOT}/examples/MakoServer/obj/release/mako.zip

dist:
	rm -rf ${outdir}
	mkdir -p ${outdir}
	cd uaserver_zip && (find -L | zip -@ ../${outdir}/uaserver.zip -x . ..) && cd ..
	cd uaclient_zip && (find -L | zip -@ ../${outdir}/uaclient.zip -x . ..) && cd ..
	cp mako.conf ${outdir}
	cp ${MAKO} ${outdir}
	cp ${MAKO_ZIP} ${outdir}
	if [ -f mako_opcua_server.zip ] ; then rm mako_opcua_server.zip ; fi
	cd ${outdir} && zip ../mako_opcua.zip mako.exe mako.zip mako.conf uaserver.zip uaclient.zip && cd ..


distclean: clean
	if [ -f mako_opcua.zip ] ; then  rm mako_opcua.zip ; fi

clean:
	if [ -d ${outdir} ] ; then rm -r ${outdir} ; fi
