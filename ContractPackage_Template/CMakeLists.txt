if(CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
  cmake_minimum_required(VERSION 3.10)

  if(POLICY CMP0141)
    cmake_policy(SET CMP0141 NEW)
    set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT "$<IF:$<AND:$<C_COMPILER_ID:MSVC>,$<CXX_COMPILER_ID:MSVC>>,$<$<CONFIG:Debug,RelWithDebInfo>:EditAndContinue>,$<$<CONFIG:Debug,RelWithDebInfo>:ProgramDatabase>>")
  endif()

  project([InterfaceName] LANGUAGES CXX)
  include(CTest)
endif()

add_library([InterfaceName]Lib
  [ImplementationFile]
)

target_include_directories([InterfaceName]Lib PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}/include"
)

target_compile_features([InterfaceName]Lib PUBLIC cxx_std_20)

if(MSVC)
  target_compile_options([InterfaceName]Lib PRIVATE /utf-8)
endif()

if(BUILD_TESTING)
  add_executable([InterfaceName]Acceptance
    tests/[InterfaceName]_acceptance.cpp
  )

  target_link_libraries([InterfaceName]Acceptance PRIVATE [InterfaceName]Lib)
  target_compile_features([InterfaceName]Acceptance PRIVATE cxx_std_20)

  if(MSVC)
    target_compile_options([InterfaceName]Acceptance PRIVATE /utf-8)
  endif()

  add_test(NAME [InterfaceName]Acceptance COMMAND [InterfaceName]Acceptance)
endif()