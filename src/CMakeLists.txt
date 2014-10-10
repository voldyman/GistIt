vala_precompile(VALA_C
  GistIt.vala
  Indicator.vala
  KeyBindingManager.vala
  ClipboardManager.vala
  GistInfoDialog.vala
  Settings.vala
  ConfigDialog.vala
  Github.vala
  config.vala
PACKAGES
    ${GISTIT_PACKAGES}
OPTIONS
    ${VALAC_OPTIONS}
)

#Here we define our executable name.
add_executable(gistit
    ${VALA_C} )

add_definitions (${DEPS_CFLAGS})

#We need to link the libraries with our Executable.
target_link_libraries(gistit ${DEPS_LIBRARIES}  gthread-2.0)

install (TARGETS gistit RUNTIME DESTINATION bin)
