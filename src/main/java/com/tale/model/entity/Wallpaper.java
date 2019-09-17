package com.tale.model.entity;

import io.github.biezhi.anima.Model;
import io.github.biezhi.anima.annotation.Table;
import lombok.Data;

@Data
@Table(name = "t_wallpapers")
public class Wallpaper extends Model {

    private Integer id;
    private String url;
    private String uid;
    private Integer status;
    private String digest;
}
