cmake_minimum_required(VERSION 3.9)

add_subdirectory(engine)

set(BINARIES
    octengine liboctengine.so camera.so gameobject.so light.so physics.so scene.so
)

ADD_CUSTOM_COMMAND(
    OUTPUT octengine
    COMMAND cp engine/octengine octengine
)

ADD_CUSTOM_COMMAND(
    OUTPUT liboctengine.so
    COMMAND cp engine/liboctengine.so liboctengine.so
)

ADD_CUSTOM_COMMAND(
    OUTPUT camera.so
    COMMAND cp engine/camera.so camera.so
)

ADD_CUSTOM_COMMAND(
    OUTPUT gameobject.so
    COMMAND cp engine/gameobject.so gameobject.so
)

ADD_CUSTOM_COMMAND(
    OUTPUT light.so
    COMMAND cp engine/light.so light.so
)

ADD_CUSTOM_COMMAND(
    OUTPUT physics.so
    COMMAND cp engine/physics.so physics.so
)

ADD_CUSTOM_COMMAND(
    OUTPUT scene.so
    COMMAND cp engine/scene.so scene.so
)

ADD_CUSTOM_TARGET(
    binaries
    ALL
    DEPENDS ${BINARIES}
)
