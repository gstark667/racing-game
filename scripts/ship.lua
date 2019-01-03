require("gameobject")
require("scene")
require("physics")
require("camera")
require("light")
require("audio")
require("ui")

function setup(scene, object)
    -- set up the camera
    camera = scene_add_camera(scene)
    scene_set_camera(scene, camera)
    camera_set_fov(camera, 90)
    camera = camera_get_gameobject(camera)
    gameobject_set_parent(camera, object)
    gameobject_set_number(camera, "xoff", 0)
    gameobject_set_number(camera, "yoff", 2)
    gameobject_set_number(camera, "zoff", 6)
    gameobject_set_integer(object, "camera", camera)

    -- set up the actual ship model
    scene_set_model(scene, object, "ship_1.dae")
    scene_set_texture(scene, object, "ship_albedo.png")
    scene_set_normal(scene, object, "ship_normal.png")
    scene_set_pbr(scene, object, "ship_pbr.png")
    physics_init_box(scene, object, 5, 1.0, 0.5, 3.0)
    physics_set_angular_factor(object, 0.04)

    -- set up the flame models
    left_flame = scene_add_gameobject(scene)
    scene_set_model(scene, left_flame, "ship_1_flame_left.dae")
    scene_set_texture(scene, left_flame, "ship_albedo.png")
    scene_set_normal(scene, left_flame, "ship_normal.png")
    scene_set_pbr(scene, left_flame, "ship_pbr.png")
    gameobject_transform(left_flame, 0, 0, 3)
    gameobject_set_parent(left_flame, object)
    gameobject_set_integer(object, "left_flame", left_flame)

    left_light = scene_add_light(scene)
    light_set_point(left_light, true)
    light_set_color(left_light, 0, 0.7, 1.0)
    gameobject_set_integer(object, "left_light", left_light)
    left_light = camera_get_gameobject(light_get_camera(left_light))
    gameobject_set_transform(left_light, -0.8, -0.3, 3)
    gameobject_set_parent(left_light, object)

    middle_flame = scene_add_gameobject(scene)
    scene_set_model(scene, middle_flame, "ship_1_flame_middle.dae")
    scene_set_texture(scene, middle_flame, "ship_albedo.png")
    scene_set_normal(scene, middle_flame, "ship_normal.png")
    scene_set_pbr(scene, middle_flame, "ship_pbr.png")
    gameobject_transform(middle_flame, 0, 0, 3)
    gameobject_set_parent(middle_flame, object)
    gameobject_set_integer(object, "middle_flame", middle_flame)

    middle_light = scene_add_light(scene)
    light_set_point(middle_light, true)
    light_set_color(middle_light, 0, 0.7, 1.0)
    gameobject_set_integer(object, "middle_light", middle_light)
    middle_light = camera_get_gameobject(light_get_camera(middle_light))
    gameobject_set_transform(middle_light, 0, 0, 3)
    gameobject_set_parent(middle_light, object)

    right_flame = scene_add_gameobject(scene)
    scene_set_model(scene, right_flame, "ship_1_flame_right.dae")
    scene_set_texture(scene, right_flame, "ship_albedo.png")
    scene_set_normal(scene, right_flame, "ship_normal.png")
    scene_set_pbr(scene, right_flame, "ship_pbr.png")
    gameobject_transform(right_flame, 0, 0, 3)
    gameobject_set_parent(right_flame, object)
    gameobject_set_integer(object, "right_flame", right_flame)

    right_light = scene_add_light(scene)
    light_set_point(right_light, true)
    light_set_color(right_light, 0, 0.7, 1.0)
    gameobject_set_integer(object, "right_light", right_light)
    right_light = camera_get_gameobject(light_get_camera(right_light))
    gameobject_set_transform(right_light, 0.8, -0.3, 3)
    gameobject_set_parent(right_light, object)

    -- set up the hover points
    fl = scene_add_gameobject(scene)
    gameobject_transform(fl, -0.4, 0, -2.9)
    gameobject_set_parent(fl, object)
    gameobject_set_integer(object, "fl", fl)
    scene_add_script(scene, fl, "test.lua")

    fr = scene_add_gameobject(scene)
    gameobject_transform(fr, 0.4, 0, -2.9)
    gameobject_set_parent(fr, object)
    gameobject_set_integer(object, "fr", fr)
    scene_add_script(scene, fr, "test.lua")

    bl = scene_add_gameobject(scene)
    gameobject_transform(bl, -0.9, 0, 2.9)
    gameobject_set_parent(bl, object)
    gameobject_set_integer(object, "bl", bl)
    scene_add_script(scene, bl, "test.lua")

    br = scene_add_gameobject(scene)
    gameobject_transform(br, 0.9, 0, 2.9)
    gameobject_set_parent(br, object)
    gameobject_set_integer(object, "br", br)
    scene_add_script(scene, br, "test.lua")

    -- setup up the audio
    source = audio_source_create(scene, middle_light, "jet.wav")
    audio_source_play(source)
    gameobject_set_integer(object, "source", source)

    source = audio_source_create(scene, left_light, "jet.wav")
    audio_source_play(source)
    gameobject_set_integer(object, "lsource", source)

    source = audio_source_create(scene, right_light, "jet.wav")
    audio_source_play(source)
    gameobject_set_integer(object, "rsource", source)

    hit_source = audio_source_create(scene, object, "hit.wav")
    audio_source_set_loop(hit_source, false)
    audio_source_set_gain(hit_source, 0.9)
    gameobject_set_integer(object, "hit_source", hit_source)

    music = audio_source_create(scene, object, "c.wav")
    audio_source_set_gain(music, 0.6)
    audio_source_play(music)

    gameobject_set_number(object, "z_axis", 0.0)
    gameobject_set_number(object, "x_rot", 0.0)
end

function dot(a, b)
    local sum = 0
    for i = 1, #a do
        sum = sum + a[i] * b[i]
    end
    return sum
end

function pid(object, name, err, delta, kp, ki, kd)
    total = gameobject_get_number(object, "total_"..name)
    last = gameobject_get_number(object, "last_"..name)

    dir = (last - err) / delta
    total = total + (err * delta)

    gameobject_set_number(object, "total_"..name, total)
    gameobject_set_number(object, "last_"..name, err)

    return ((kp * err) + (ki * total) + (kd * dir)) * delta
end

function tilt(scene, object, value)
    fl = gameobject_get_integer(object, "fl")
    fr = gameobject_get_integer(object, "fr")
    bl = gameobject_get_integer(object, "bl")
    br = gameobject_get_integer(object, "br")

    scene_send_event(fl, "height", value)
    scene_send_event(fr, "height", value)
    scene_send_event(bl, "height", -value)
    scene_send_event(br, "height", -value)
end

function update(scene, object, delta)
    x_axis_in = gameobject_get_number(object, "x_axis") * -2
    z_axis_in = gameobject_get_number(object, "z_axis") * 60

    x_rot, y_rot, z_rot = gameobject_unrotate_vector(object, physics_get_angular_velocity(object))
    x_vel, y_vel, z_vel = gameobject_unrotate_vector(object, physics_get_velocity(object))
    vel = math.sqrt(x_vel * x_vel + y_vel * y_vel + z_vel * z_vel)

    -- update the spedometer
    spedometer = gameobject_get_integer(object, "speed_element")
    --ui_element_set_text(spedometer, "velocity: " .. math.sqrt(z_vel * z_vel + x_vel * x_vel + y_vel * y_vel))

    x_axis_rot = pid(object, "rot", y_rot - x_axis_in, delta, 80.0, 0.0, -1.0)
    z_axis = pid(object, "zvel", z_axis_in - z_vel, delta, 3.0, 0.0, 0.0)
    x_axis = pid(object, "xvel", x_axis_in - x_vel, delta, 1.0, 0.0, 0.0)

    x_force, y_force, z_force = gameobject_rotate_vector(object, x_axis_rot, 0, 0)
    x_pos, y_pos, z_pos = gameobject_rotate_vector(object, 0, 0.02, -0.2)
    physics_apply_force(object, x_force, y_force, z_force, x_pos, y_pos, z_pos)

    x_force, y_force, z_force = gameobject_rotate_vector(object, x_axis, 0, z_axis)
    physics_apply_force(object, x_force, y_force, z_force, 0, 0, 0)

    -- move the camera
    camera = gameobject_get_integer(object, "camera")
    x, y, z = gameobject_get_transform(camera)
    xoff = gameobject_get_number(camera, "xoff") - (x_vel * 0.05)
    yoff = gameobject_get_number(camera, "yoff") - (y_vel * 0.05)
    zoff = gameobject_get_number(camera, "zoff") - (z_vel * 0.05)
    x = pid(camera, "x", xoff - x, delta, 6, 2, 0)
    y = pid(camera, "y", yoff - y, delta, 6, 2, 0)
    z = pid(camera, "z", zoff - z, delta, 6, 2, 0)
    gameobject_transform(camera, x, y, z)

    -- scale the flames
    left_flame = gameobject_get_integer(object, "left_flame")
    left_light = gameobject_get_integer(object, "left_light")
    middle_flame = gameobject_get_integer(object, "middle_flame")
    middle_light = gameobject_get_integer(object, "middle_light")
    right_flame = gameobject_get_integer(object, "right_flame")
    right_light = gameobject_get_integer(object, "right_light")
    left_value = math.max(-x_axis_in / 8.0 - z_axis_in / 100.0, 0.0) + math.random() * 0.2
    middle_value = math.max(-z_axis_in / 60.0, 0.0) + math.random() * 0.2
    right_value = math.max(x_axis_in / 8.0 - z_axis_in / 100.0, 0.0) + math.random() * 0.2
    gameobject_set_scale(left_flame, 1, 1, left_value)
    light_set_brightness(left_light, left_value * 2)
    gameobject_set_scale(middle_flame, 1, 1, middle_value)
    light_set_brightness(middle_light, middle_value)
    gameobject_set_scale(right_flame, 1, 1, right_value)
    light_set_brightness(right_light, right_value * 2)

    -- modulate the sound
    source = gameobject_get_integer(object, "source")
    lsource = gameobject_get_integer(object, "lsource")
    rsource = gameobject_get_integer(object, "rsource")
    pitch = math.abs(z_vel) * 0.02 + 1.0 + (math.random() * math.abs(z_vel) * 0.001)
    vol = math.abs(z_force) * 0.20 + 0.7
    audio_source_set_pitch(source, pitch)
    audio_source_set_pitch(lsource, pitch + 0.3)
    audio_source_set_pitch(rsource, pitch + 0.3)
    audio_source_set_gain(source, vol)
    audio_source_set_gain(lsource, vol)
    audio_source_set_gain(rsource, vol)
end

function on_event(scene, object, name, value)
    if name == "x_axis" or name == "z_axis" or name =="y_axis" then
        gameobject_set_number(object, name, value)
    elseif name == "x_look" or name == "y_look" then
        gameobject_set_number(object, name, value)
    end
end

function on_collision_enter(scene, object, other)
    x, y, z = physics_get_velocity(object)
    vel = math.sqrt(x*x + y*y + z*z)
    source = gameobject_get_integer(object, "hit_source")
    audio_source_set_gain(source, vel * 0.025)
    audio_source_set_pitch(source, vel * 0.01 + 0.5)
    audio_source_play(source)
end
