# Makefile for vnStatSVG
# Author: falcon <zhangjinw@gmail.com>
# Update: 2008-06-16

USR_BIN=/usr/bin/
CGI_BIN=/usr/lib/cgi-bin/
VNSTATSVG_ROOT=/var/www/
XML_DUMP_METHOD=p

# get current User id, if not 
ID:=$(shell id -u)
VNSTAT_SH=$(shell ls $(CGI_BIN)vnstat.sh 2>/dev/null)
SIDEBAR_XML=$(shell ls $(VNSTATSVG_ROOT)sidebar.xml* 2>/dev/null)
DATE=$(shell date "+%y%m%d")
RM=rm -f
VNSATXML=vnstatxml-1.6
VNSTATXML_STANDALONE=vnstatxml-standalone-1.6
ADMIN_FILES=index.xhtml index.xsl sidebar.xml sidebar.xsl vnstat.xsl vnstat.js vnstat.css menu.xml menu.xsl
CGI_FILES=httpclient proxy.sh vnstat.sh

# read user's input

all:
	make httpclient -C src/cgi-bin/
ifeq ($(XML_DUMP_METHOD), c)
	make vnstatxml_standalone -C src/cgi-bin/
endif
ifeq ($(XML_DUMP_METHOD), p)
	make vnstatxml -C src/cgi-bin/
endif

install:
ifeq ($(CGI_BIN),)
	@echo "please configure the cgi-bin directory firstly:"
	@echo "        $ ./configure"
	@exit -1
else
ifeq ($(VNSTATSVG_ROOT),)
	@echo "please configure the VNSTATSVG_ROOT directory firstly:"
	@echo "        $ ./configure"
	@exit -1
endif
endif

ifneq ($(VNSTAT_SH),)
	@echo "Perhaps you have installed vnStatSVG before, EXIT directly."
	@echo "if you really want to install it again, please uninstall it firstly."
	@echo -e "         \033[;31m make uninstall\033[0m"
	@exit -1 
endif

ifneq ($(ID),0)
	@echo "You should install vnStatSVG as root, "
	@exit -1
else
ifneq ($(SIDEBAR_XML),)
	@echo "there is an old configuration file($(SIDEBAR_XML)) there."
	@echo "if you want to use it, please execute this command manually after finish installation:"
	@echo -e "        \033[;31m cp $(SIDEBAR_XML) $(VNSTATSVG_ROOT)sidebar.xml\033[0m\n"
endif
	@echo "Installing the administration pages..."
	@mkdir -p $(VNSTATSVG_ROOT)/
	@$(foreach f,$(ADMIN_FILES), cp -r src/admin/$(f) $(VNSTATSVG_ROOT);)
	@cat src/admin/vnstat.xsl | egrep -v '\-\->|^ *$$' > $(VNSTATSVG_ROOT)vnstat.xsl
	@echo "Installing the CGI programs..."
	@cp -r src/cgi-bin/httpclient $(CGI_BIN)
	@cp -r src/cgi-bin/proxy.sh $(CGI_BIN)
	@cp -r src/cgi-bin/vnstat-$(XML_DUMP_METHOD).sh  $(CGI_BIN)/vnstat.sh
ifeq ($(XML_DUMP_METHOD),c)
	@cp -r src/cgi-bin/$(VNSTATXML_STANDALONE)/vnstatxml $(CGI_BIN)
endif
ifeq ($(XML_DUMP_METHOD),p)
	@cp -r src/cgi-bin/$(VNSATXML)/src/vnstat $(USR_BIN)
endif
	@echo "finish installing. :-)"
	@echo "-----------------------------------------------"
	@echo -e "\033[;31mNOTE\033[0m: now, if you are installing vnStatSVG in localhost, try this link, http://localhost/index.xhtml."
	@echo -e "otherwise, please configure \033[;34m$(VNSTATSVG_ROOT)sidebar.xml\033[0m firstly."
	@echo -e "\033[;31mRecommend\033[0m: PLEASE set \033[;34mindex.xhtml\033[0m as the homepage via configuring the http server."
	@exit 0
endif
uninstall:
ifneq ($(ID),0)
	@echo "You should uninstall vnStatSVG as root, "
	@exit -1
else
	@echo "removing the CGI programs..."

	@$(foreach f,$(CGI_FILES), rm -r $(CGI_BIN)/$(f);)
	@rm -r $(CGI_BIN)/{httpclient,proxy.sh,vnstat.sh}
ifeq ($(XML_DUMP_METHOD),c)
	@rm $(CGI_BIN)/vnstatxml
endif

# Here, we not really uninstall vnstat, because if you uninstall it, it will delete all of the database collected there
#ifeq ($(XML_DUMP_METHOD),p)
#	make uninstall -C src/cgi-bin/$(VNSTATXML)
#endif
	@echo "finish uninstalling. :-)"
	@echo "removing the administration pages..."
ifneq ($(SIDEBAR_XML),)
	@echo "backup the old configuration file..."
	@cp -r $(VNSTATSVG_ROOT)sidebar.xml /tmp/
endif
ifneq ($(SIDEBAR_XML),)
	@echo "it has been saved as $(VNSTATSVG_ROOT)sidebar.xml-$(DATE)"
	@$(foreach f,$(ADMIN_FILES), rm -r $(VNSTATSVG_ROOT)/$(f);)
	@mkdir -p $(VNSTATSVG_ROOT)/
	@mv /tmp/sidebar.xml $(VNSTATSVG_ROOT)sidebar.xml-$(DATE)
endif
endif
clean:
	make clean -C src/cgi-bin
ifeq ($(XML_DUMP_METHOD), c)
	$(RM) src/cgi-bin/vnstatxml
	make clean -C src/cgi-bin/$(VNSTATXML_STANDALONE)
endif
ifeq ($(XML_DUMP_METHOD), p)
	make clean -C src/cgi-bin/$(VNSATXML)
endif
distclean:
	make clean -C src/cgi-bin
	$(RM) src/cgi-bin/vnstatxml
	make clean -C src/cgi-bin/$(VNSTATXML_STANDALONE)
	make clean -C src/cgi-bin/$(VNSATXML)
