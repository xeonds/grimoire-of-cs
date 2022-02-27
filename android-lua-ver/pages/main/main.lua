require "import"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.Typeface"
import "androidx.recyclerview.widget.RecyclerView"
local MaterialAlertDialogBuilder = luajava.bindClass "com.google.android.material.dialog.MaterialAlertDialogBuilder"
local FusionUtil = luajava.bindClass "net.fusionapp.core.util.FusionUtil"
local BasePagerAdapter = luajava.bindClass "net.fusionapp.core.ui.adapter.BasePagerAdapter"
import "androidx.recyclerview.widget.*"
local LuaRecyclerAdapter = luajava.bindClass "com.androlua.LuaRecyclerAdapter"
local ViewPager = luajava.bindClass "androidx.viewpager.widget.ViewPager"
import "com.google.android.material.card.MaterialCardView"
JSON=import "cjson"
import "layout"
import "config"

function onDrawerListItemClick(data, recyclerView, listIndex, itemIndex)
  local listData = data.get(listIndex);
  local itemData = listData.get(itemIndex);
  local itemTitle = itemData.getTitle();
  switch(itemTitle)do
   case "编程语言"
    loadHomeList("programming")
   case "操作系统"
    loadHomeList("os")
   case "夜间模式"
    if itemData.isChecked() then
      switchTheme(itemData, false, "Default_Light.json")
     else
      switchTheme(itemData, true, "Dark.json")
    end
   case "设置"
    activity.newActivity("setting")
   case "关于"
    MaterialAlertDialogBuilder(activity)
    .setTitle("关于软件")
    .setMessage("一个关于计算机科学的小册子")
    .setPositiveButton("确定",nil)
    .show()
   case "退出"
    activity.finish()
  end
  this.UiManager.toggleDrawer()
end

function onSearchEvent(keyword)
  print("Search keyword:"..keyword)
end

function onMenuItemClick(title)
  switch(title) do
   case "菜单1"
    print("Click : Overflow Button")
   case "菜单2"
    --do sth
  end
end

--fun def
function switchTheme(listItemData, isNightMode, newThemeName)
  function recreate()
    activity.finish();
    activity.overridePendingTransition(android.R.anim.fade_in,android.R.anim.fade_out);
    activity.startFusionActivity(activity.getLoader().getPageName());
  end

  listItemData.setChecked(isNightMode)
  activity.getLoader().updatePageConfig()
  FusionUtil.changeTheme(activity.getLoader().getProjectDir().getAbsolutePath(), newThemeName)
  FusionUtil.setNightMode(isNightMode)
  recreate()
end

function getDatabase()
  local dbList={"programming","os"}
  local apiUrl="http://www.jiujiuer.xyz/pages/cs/core.php?source="
  local db={}
  if activity.getSharedData("数据源")~=nil and activity.getSharedData("数据源")~="" then
    apiUrl=activity.getSharedData("数据源")
  end
  for _,v in pairs(dbList) do
    Http.get(apiUrl..v,function(code,content,cookie,header)
      if code==200 then
        local data=JSON.decode(content)
        if(data~=nil)then
          for j,k in pairs(data.config.db) do
            activity.setSharedData("table_"..j,JSON.encode(k))
          end
          data.config.db=nil
          activity.setSharedData("db_"..v,JSON.encode(data))
        end
       else
        print("数据库连接失败："..code)
      end
    end)
    if activity.getSharedData("db_"..v)~=nil then
      db[v]=JSON.decode(activity.getSharedData("db_"..v))
    end
  end
  return JSON.encode(db)
end

--main
local viewPagerList=ArrayList()
viewPagerList.add(loadlayout(layout))
this.UiManager.viewPager.setAdapter(BasePagerAdapter(viewPagerList))

function loadHomeList(dbName)
  local db=JSON.decode(getDatabase())[dbName]
  local homeListData={}

  if(db.config.status=="release")then
    for _,v in pairs(db.db) do
      function genCardLayout(cardTitle,cardAdp)
        return {
          title={
            text=cardTitle,
          },
          itemList={
            LayoutManager=GridLayoutManager(activity,3),
            Adapter=cardAdp,
          }
        }
      end
      local data={}
      local adp=LuaRecyclerAdapter(activity,data,innerItem)
      adp.clickViewId="innerCard"
      adp.onItemClick=function(adapter,itemView,view,pos)
        local bundle=Bundle()
        bundle.putString("table","table_"..v.data[pos+1].db)
        activity.startFusionActivity("index",bundle)
        return true
      end
      for _,t in pairs(v.data) do
        table.insert(data,{text={text=t.title}})
      end
      table.insert(homeListData,genCardLayout(v.group,adp))
    end
    progLangList.layoutManager=LinearLayoutManager(activity)
    progLangList.Adapter=LuaRecyclerAdapter(activity,homeListData,item)
    progLangList.Adapter.clickViewId="itemList"
   else
    progLangListEmpty.visibility=0
  end
end

loadHomeList("programming")