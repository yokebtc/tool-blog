package com.tale.service;

import java.util.List;
import java.util.Random;

import com.blade.ioc.annotation.Bean;
import com.tale.model.entity.Wallpaper;

import io.github.biezhi.anima.Anima;
import io.github.biezhi.anima.page.Page;

@Bean
public class WallpaperService {
	
	public Wallpaper getRandom() {
		Page<Wallpaper> page = Anima.select().from(Wallpaper.class).where("status = 0").page(1, 100);
		List<Wallpaper> rows = page.getRows();
		Random random = new Random();
		int nextInt = random.nextInt(rows.size());
		Wallpaper wallpaper = rows.get(nextInt);
		Anima.update().from(Wallpaper.class).set("status", 1).where("id = ?", wallpaper.getId());
		return wallpaper;
	}
	
	public void updateByStatus(String digest) {
		Anima.update().from(Wallpaper.class).set("status", 0).where("digest = ?", digest);
	}
}
