<?php

if (isset($_GET['source'])) {
    $db_dir = opendir("./db/");
    while (false !== $item = readdir($db_dir)) {
        $nextPath = "./db/" . $item;
        if ($item != '.' && $item != '..' && is_dir($nextPath))
            $db_list[$item] = $nextPath.'/';
    }
    if ($db_list[$db_path = $_GET['source']] != null) {
        $db = json_decode(file_get_contents($db_list[$db_path].'main.json'), true);
        $db_dir = opendir($db_list[$db_path]);
        while (false !== $item = readdir($db_dir)) {
            if ($item != '.' && $item != '..' && $item != 'main.json')
                $db['config']['db'][explode('.json', $item)[0]] = json_decode(file_get_contents($db_list[$db_path].$item), true);
        }
        echo json_encode($db);
    }
} elseif (isset($_GET['db_modify'])) {
    $db = json_decode(file_get_contents($_POST['path']), true);
    $db[] = array('title' => $_POST['title'], 'content' => $_POST['content']);
    file_put_contents($_POST['path'], json_encode($db));
    echo json_encode(array('result' => 'success', 'db' => $_POST['path']));
} elseif (isset($_GET['get_list'])) {
    $db_dir = opendir("./db/");
    while (false !== $item = readdir($db_dir)) {
        $nextPath = "./db/" . $item;
        if ($item != '.' && $item != '..' && is_dir($nextPath))
            $db_list[$item] = $nextPath.'/';
    }
    foreach ($db_list as $sub_db) {
        $db_dir = opendir($sub_db);
        while (false !== $item = readdir($db_dir)) {
            $nextPath = $sub_db . $item;
            if ($item != '.' && $item != '..' && !is_dir($nextPath) && $item != 'main.json')
                $res[$item] = $nextPath;
        }
    }
    echo json_encode(array("list" => $res));
} elseif (isset($_GET['get_sub_list'])) {
    echo json_encode(array("list" => json_decode(file_get_contents($_GET['get_sub_list']), true)));
} elseif (isset($_GET['remove_item'])) {
    $db = json_decode(file_get_contents($_POST['path']), true);
    array_splice($db, $_POST['item'], 1);
    file_put_contents($_POST['path'], json_encode($db));
    echo json_encode(array("title" =>"success"));
}