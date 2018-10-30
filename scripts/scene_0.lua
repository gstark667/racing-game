require("scene")
require("gameobject")
require("physics")
require("light")
require("camera")

function setup(scene, object)

    --for x = 0, 10 do
    --    for y = 0, 10 do
    --      for i = 1, 2 do
    --        cube = scene_add_gameobject(scene)
    --        scene_set_model(scene, cube, "scifi_cube.dae")
    --        gameobject_scale(cube, 1)
    --        gameobject_transform(cube, x*1, i, y*1)
    --        physics_init_box(scene, cube, 10, 0.5, 0.5, 0.5)
    --      end
    --    end
    --end
    cube = scene_add_gameobject(scene)
    scene_set_model(scene, cube, "cube.dae")
    gameobject_scale(cube, 0.5, 0.5, 0.5)
    gameobject_transform(cube, 0, 10, 0)
    physics_init_box(scene, cube, 1, 0.5, 0.5, 0.5)

    --plane = scene_add_gameobject(scene)
    --scene_set_model(scene, plane, "plane.dae")
    --gameobject_transform(plane, 0, -0.1, 0)
    --gameobject_scale(plane, 50)
    --physics_init_box(scene, plane, 0, 50, 0.01, 50)
    example = scene_add_gameobject(scene)
    gameobject_transform(example, 0, 0, 0)
    scene_set_model(scene, example, "track_2.dae")
    scene_set_texture(scene, example, "track_albedo.png")
    scene_set_normal(scene, example, "track_normal.png")
    scene_set_pbr(scene, example, "track_pbr.png")
    physics_init_mesh(scene, example, 0)
    physics_set_rotation(example, -math.pi/2.0, 0, 0)

    --balls = scene_add_gameobject(scene)
    --gameobject_transform(balls, 0, 1, 0)
    --scene_set_model(scene, balls, "pbr_balls.dae")
    --scene_set_texture(scene, balls, "test.png")
    --scene_set_pbr(scene, balls, "pbr_balls.png")

    ship = scene_add_gameobject(scene)
    gameobject_transform(ship, 0, 1.2, 0)
    scene_add_script(scene, ship, "ship.lua")

    --player = scene_add_gameobject(scene)
    --scene_set_model(scene, player, "capsule.dae")
    --scene_add_script(scene, player, "player.lua")
    --physics_set_position(player, 0, 1, 5)

    sun = scene_add_light(scene)
    scene_enable_shadow(scene, sun)
    sun_cam = light_get_camera(sun)
    camera_set_fov(sun, -1)
    camera_set_size(sun, 10, 10)
    sun_obj = camera_get_gameobject(sun_cam)
    gameobject_rotate(sun_obj, -math.pi/4.0, 0.0, 0.0)
    gameobject_transform(sun_obj, 0, 10, 10)
    gameobject_set_integer(sun_obj, "target", ship)
    scene_add_script(scene, sun_obj, "sun.lua")
end
