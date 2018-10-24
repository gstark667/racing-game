require("gameobject")
require("scene")
require("physics")

function setup(scene, object)
    gameobject_scale(object, 0.1)
    --scene_set_model(scene, object, "sphere.dae")

    gameobject_set_number(object, "height", 1.0)
    gameobject_set_number(object, "total_err", 0.0)
    gameobject_set_number(object, "last_err", -1.0)
end

function update(scene, object, delta)
    kp, ki, kd = 60.0, 0.0, 2.0
    x, y, z = gameobject_get_global_transform(object)
    tx, ty, tz = gameobject_rotate_vector(object, 0, -4, 0)
    hit, dist = physics_ray_test(scene, x, y, z, x + tx, y + ty, z + tz)

    if hit then
        height = gameobject_get_number(object, "height") + gameobject_get_number(object, "height_off")
        total_err = gameobject_get_number(object, "total_err")
        last_err = gameobject_get_number(object, "last_err")

        err = dist - height -- position element
        total_err = total_err + (err * delta) -- integral element
        dir_err = (err - last_err) / delta -- derivative element

        force = ((kp * err) + (ki * total_err) + (kd * dir_err)) * delta
        x_force, y_force, z_force = gameobject_rotate_vector(object, 0, -force, 0)
        parent = gameobject_get_parent(object)
        px, py, pz = gameobject_get_global_transform(parent)
        physics_apply_force(parent, x_force, y_force, z_force, x-px, y-py, z-pz)

        gameobject_set_number(object, "total_err", total_err)
        gameobject_set_number(object, "last_err", err)
    end
end

function on_event(scene, object, event, value)
    if event == "height" then
        gameobject_set_number(object, "height_off", value)
    end
end
