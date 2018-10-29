cmake_minimum_required(VERSION 3.9)

add_subdirectory(engine)

ADD_CUSTOM_COMMAND(
    OUTPUT octengine
    DEPENDS engine/octengine
    COMMAND cp engine/octengine octengine
)

ADD_CUSTOM_COMMAND(
    OUTPUT libs
    COMMAND mkdir libs
)

foreach(lib ${LUALIBS})
ADD_CUSTOM_COMMAND(
    OUTPUT libs/${lib}
    DEPENDS libs engine/${lib}
    COMMAND cp engine/${lib} libs/${lib}
)
SET(BINARIES ${BINARIES} "libs/${lib}")
endforeach()

ADD_CUSTOM_TARGET(
    binaries
    ALL
    DEPENDS ${BINARIES} libs
)
