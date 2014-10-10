
# We define the minimum cmake. This is standard for elementary OS
cmake_minimum_required (VERSION 2.8)

#We define the minimum policy version
cmake_policy(VERSION 2.8)


#We define out project name.
project(gistit)

set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")
set (PKGDATADIR "${DATADIR}/gistit")
set (GETTEXT_PACKAGE "gistit")
add_definitions(-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")
set (RELEASE_NAME "Phela")
set (VERSION "0.1")

configure_file (${CMAKE_SOURCE_DIR}/src/config.vala.cmake ${CMAKE_SOURCE_DIR}/src/config.vala)

#Here we load the modules we downloaded earlier and placed into the ./cmake directory
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake )

# Vala
find_package (Vala REQUIRED)
include (ValaVersion)
ensure_vala_version ("0.22.1" MINIMUM)
include (ValaPrecompile)

find_package(PkgConfig)

set(TARGET_GLIB 2.32)

pkg_check_modules(DEPS REQUIRED
  libsoup-2.4
  json-glib-1.0
  gtk+-3.0
  json-glib-1.0
  libnotify
  gthread-2.0
  appindicator3-0.1
  gdk-x11-3.0
  x11
  libsoup-2.4)

set(CFLAGS
    ${DEPS_CFLAGS}
    ${DEPS_CFLAGS_OTHER}
    -D_VERSION=\"${VERSION}\"
    -D_INSTALL_PREFIX=\"${CMAKE_INSTALL_PREFIX}\"
    -D_SOURCE_ROOT_DIR=\"${CMAKE_SOURCE_DIR}\"
    -D_GSETTINGS_DIR=\"${CMAKE_BINARY_DIR}/gsettings\"
    -DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\"
    -DLANGUAGE_SUPPORT_DIRECTORY=\"${LANGUAGE_SUPPORT_DIRECTORY}\"
)

set(GISTIT_PACKAGES
    gtk+-3.0  libsoup-2.4 json-glib-1.0 libnotify>=0.7.5 appindicator3-0.1
    x11 gdk-x11-3.0
)

set(VALAC_OPTIONS
    --vapidir=${CMAKE_SOURCE_DIR}/vapi
    --target-glib=${TARGET_GLIB}
    --thread
    --fatal-warnings
)

set(LIB_PATHS ${DEPS_LIBRARY_DIRS})
link_directories(${LIB_PATHS})
add_definitions(${CFLAGS} "-DGETTEXT_PACKAGE=\"gistit\"")

configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake_uninstall.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
    IMMEDIATE @ONLY
)

add_custom_target(
    uninstall
    COMMAND
        ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake
    COMMAND
        ${glib_schema_compiler} ${GSETTINGS_DIR}
)

add_subdirectory(data)
add_subdirectory (src)
add_subdirectory (po)