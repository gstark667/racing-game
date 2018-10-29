cmake_minimum_required(VERSION 3.9)

add_subdirectory(engine)

IF(APPLE)
        set(BINARIES
            octengine liboctengine.dylib camera.dylib gameobject.dylib light.dylib physics.dylib scene.dylib audio.dylib
        )

        ADD_CUSTOM_COMMAND(
            OUTPUT octengine
            DEPENDS engine/octengine
            COMMAND cp engine/octengine octengine
        )

        ADD_CUSTOM_COMMAND(
            OUTPUT liboctengine.dylib
            DEPENDS engine/liboctengine.dylib
            COMMAND cp engine/liboctengine.dylib liboctengine.dylib
        )

        ADD_CUSTOM_COMMAND(
            OUTPUT camera.dylib
            DEPENDS engine/camera.dylib
            COMMAND cp engine/camera.dylib camera.dylib
        )

        ADD_CUSTOM_COMMAND(
            OUTPUT gameobject.dylib
            DEPENDS engine/gameobject.dylib
            COMMAND cp engine/gameobject.dylib gameobject.dylib
        )

        ADD_CUSTOM_COMMAND(
            OUTPUT light.dylib
            DEPENDS engine/light.dylib
            COMMAND cp engine/light.dylib light.dylib
        )

        ADD_CUSTOM_COMMAND(
            OUTPUT physics.dylib
            DEPENDS engine/physics.dylib
            COMMAND cp engine/physics.dylib physics.dylib
        )

        ADD_CUSTOM_COMMAND(
            OUTPUT scene.dylib
            DEPENDS engine/scene.dylib
            COMMAND cp engine/scene.dylib scene.dylib
        )

        ADD_CUSTOM_COMMAND(
            OUTPUT audio.dylib
            DEPENDS engine/audio.dylib
            COMMAND cp engine/audio.dylib audio.dylib
        )
ELSEIF(UNIX)
        set(BINARIES
            octengine liboctengine.so camera.so gameobject.so light.so physics.so scene.so audio.so
        )

        ADD_CUSTOM_COMMAND(
            OUTPUT octengine
            DEPENDS engine/octengine
            COMMAND cp engine/octengine octengine
        )

        ADD_CUSTOM_COMMAND(
            OUTPUT liboctengine.so
            DEPENDS engine/liboctengine.so
            COMMAND cp engine/liboctengine.so liboctengine.so
        )

        ADD_CUSTOM_COMMAND(
            OUTPUT camera.so
            DEPENDS engine/camera.so
            COMMAND cp engine/camera.so camera.so
        )

        ADD_CUSTOM_COMMAND(
            OUTPUT gameobject.so
            DEPENDS engine/gameobject.so
            COMMAND cp engine/gameobject.so gameobject.so
        )

        ADD_CUSTOM_COMMAND(
            OUTPUT light.so
            DEPENDS engine/light.so
            COMMAND cp engine/light.so light.so
        )

        ADD_CUSTOM_COMMAND(
            OUTPUT physics.so
            DEPENDS engine/physics.so
            COMMAND cp engine/physics.so physics.so
        )

        ADD_CUSTOM_COMMAND(
            OUTPUT scene.so
            DEPENDS engine/scene.so
            COMMAND cp engine/scene.so scene.so
        )

        ADD_CUSTOM_COMMAND(
            OUTPUT audio.so
            DEPENDS engine/audio.so
            COMMAND cp engine/audio.so audio.so
        )
ENDIF()

ADD_CUSTOM_TARGET(
    binaries
    ALL
    DEPENDS ${BINARIES} mainoctengine liboctengine gameobject scene physics camera light audio
)
