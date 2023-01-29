include $(TOPDIR)/rules.mk

# Name, version and release number
# The name and version of your package are used to define the variable to point to the build directory of your package: $(PKG_BUILD_DIR)
PKG_NAME:=wm_agent
PKG_VERSION:=0.0.1
PKG_RELEASE:=1

SOURCE_DIR:=./src

include $(INCLUDE_DIR)/package.mk

# Package definition; instructs on how and where our package will appear in the overall configuration menu ('make menuconfig')
define Package/wm_agent
	SECTION:=examples
	CATEGORY:=Examples
	TITLE:=wm_agent app
	DEPENDS:=+libubus-lua +libubox-lua +libuci-lua +libmosquitto-ssl +lua-mosqutto
endef

# Package description; a more verbose description on what our package does
define Package/wm_agent/description
	Sample MQTT monitoring agent.
endef

define Build/Compile
endef

# Package install instructions; create a directory inside the package to hold our executable, and then copy the executable we built previously into the folder
define Package/wm_agent/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_BIN) $(SOURCE_DIR)/wm_agent $(1)/usr/bin
	$(INSTALL_CONF) $(SOURCE_DIR)/wm2022 $(1)/etc/config
endef

# This command is always the last, it uses the definitions and variables we give above in order to get the job done
$(eval $(call BuildPackage,wm_agent))
