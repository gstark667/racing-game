require("gameobject")


function setup(scene, object)
    gameobject_set_number(object, "xvel", 0.0)
    gameobject_set_number(object, "yvel", 0.0)
    gameobject_set_number(object, "zvel", 0.0)
end

function pid(object, name, err, delta, kp, ki, kd)
    total = gameobject_get_number(object, "total_"..name)
    last = gameobject_get_number(object, "last_"..name)

    dir = (last - err) / delta
    total = total + (err * delta)

    gameobject_set_number(object, "total_"..name, total)
    gameobject_set_number(object, "last_"..name, err)

    return (kp * err) + (ki * total) + (kd * dir)
end

function update(scene, object, delta)
end

function update_camera(object, delta)
    xvel = gameobject_get_number(object, "xvel")
    yvel = gameobject_get_number(object, "yvel")
    zvel = gameobject_get_number(object, "zvel")

    xoff = gameobject_get_number(object, "xoff")
    yoff = gameobject_get_number(object, "yoff")
    zoff = gameobject_get_number(object, "zoff")
    target = gameobject_get_integer(object, "target")

    xc, yc, zc = gameobject_get_global_transform(object)
    xt, yt, zt = gameobject_get_global_transform(target)
    x, y, z = gameobject_rotate_vector(target, xoff, yoff, zoff)
    x = xt + x
    y = yt + y
    z = zt + z

    xvel = xvel + pid(object, 'x', x - xc, delta, 0.005, 0, 0.0)
    yvel = yvel + pid(object, 'y', y - yc, delta, 0.005, 0, 0.0)
    zvel = zvel + pid(object, 'z', z - zc, delta, 0.005, 0, 0.0)

    gameobject_transform(object, xvel * delta, yvel * delta, zvel * delta)
    gameobject_set_rotation(object, gameobject_get_global_rotation(target))

    gameobject_set_number(object, "xvel", xvel)
    gameobject_set_number(object, "yvel", yvel)
    gameobject_set_number(object, "zvel", zvel)
end

function on_event(scene, object, event, value)
    if event == "update_camera" then
        update_camera(object, value)
    end
end
