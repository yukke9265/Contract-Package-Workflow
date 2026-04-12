# CMakeList.txt : InterfaceDriven の CMake プロジェクト。ソースを含めて、次を定義します:
# プロジェクト専用ロジックはこちらです。
#
cmake_minimum_required (VERSION 3.8)

# サポートされている場合は、MSVC コンパイラのホット リロードを有効にします。
if (POLICY CMP0141)
  cmake_policy(SET CMP0141 NEW)
  set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT "$<IF:$<AND:$<C_COMPILER_ID:MSVC>,$<CXX_COMPILER_ID:MSVC>>,$<$<CONFIG:Debug,RelWithDebInfo>:EditAndContinue>,$<$<CONFIG:Debug,RelWithDebInfo>:ProgramDatabase>>")
endif()

project ("InterfaceDriven")

enable_testing()

add_library(BoundedQueueLib
    "ContractPackage_BoundedQueue/BoundedQueue.cpp"
)

target_include_directories(BoundedQueueLib PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}/ContractPackage_BoundedQueue/include"
)

add_executable(BoundedQueueAcceptance
    "ContractPackage_BoundedQueue/tests/BoundedQueue_acceptance.cpp"
)

target_link_libraries(BoundedQueueAcceptance PRIVATE BoundedQueueLib)

add_test(NAME BoundedQueueAcceptance COMMAND BoundedQueueAcceptance)

if (CMAKE_VERSION VERSION_GREATER 3.12)
  set_property(TARGET BoundedQueueLib PROPERTY CXX_STANDARD 20)
  set_property(TARGET BoundedQueueAcceptance PROPERTY CXX_STANDARD 20)
endif()

if (MSVC)
  target_compile_options(BoundedQueueLib PRIVATE /utf-8)
  target_compile_options(BoundedQueueAcceptance PRIVATE /utf-8)
endif()

# TODO: テストを追加し、必要な場合は、ターゲットをインストールします。
