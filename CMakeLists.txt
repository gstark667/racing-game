cmake_minimum_required(VERSION 3.9)

add_subdirectory(engine)

if(WIN32)
ADD_CUSTOM_COMMAND(
    OUTPUT octengine.exe
    DEPENDS engine/octengine.exe
    COMMAND cp engine/octengine.exe octengine.exe
)
else()
ADD_CUSTOM_COMMAND(
    OUTPUT octengine
    DEPENDS engine/octengine
    COMMAND cp engine/octengine octengine
)
endif()

ADD_CUSTOM_COMMAND(
    OUTPUT libs
    COMMAND mkdir libs
)

ADD_CUSTOM_COMMAND(
    OUTPUT shaders
    COMMAND mkdir shaders
)

foreach(lib ${LUALIBS})
ADD_CUSTOM_COMMAND(
    OUTPUT libs/${lib}
    DEPENDS libs engine/${lib}
    COMMAND cp engine/${lib} libs/${lib}
)
SET(BINARIES ${BINARIES} "libs/${lib}")
endforeach()

foreach(shader ${SHADERS})
ADD_CUSTOM_COMMAND(
    OUTPUT ${shader}
    DEPENDS shaders engine/${shader}
    COMMAND cp engine/${shader} ${shader}
)
endforeach()

ADD_CUSTOM_TARGET(
    binaries
    ALL
    DEPENDS ${BINARIES} ${SHADERS} libs shaders
)
