require"import"
import "android.widget.*"
import "android.view.*"
import "android.os.*"
import "net.fusionapp.core.ui.adapter.BasePagerAdapter"
import "androidx.recyclerview.widget.RecyclerView"
import "androidx.recyclerview.widget.LinearLayoutManager"
import "androidx.appcompat.widget.PopupMenu"
local MaterialCardView = luajava.bindClass "com.google.android.material.card.MaterialCardView"
local RelativeLayout = luajava.bindClass "android.widget.RelativeLayout"
JSON=import "cjson"

--导入layout布局
import "layout"


--UI管理器
UiManager=this.UiManager
local viewPager=UiManager.viewPager
--加载layout
local pageList=ArrayList()
pageList.add(loadlayout(layout))
viewPager.setAdapter(BasePagerAdapter(pageList))

function utf8sub(str, startChar, numChars)
  local function chsize(char)
    if not char then
      print("not char")
      return 0
     elseif char > 240 then
      return 4
     elseif char > 225 then
      return 3
     elseif char > 192 then
      return 2
     else
      return 1
    end
  end
  local startIndex = 1
  while startChar > 1 do
    local char = string.byte(str, startIndex)
    startIndex = startIndex + chsize(char)
    startChar = startChar - 1
  end
  local currentIndex = startIndex
  while numChars > 0 and currentIndex <= #str do
    local char = string.byte(str, currentIndex)
    currentIndex = currentIndex + chsize(char)
    numChars = numChars -1
  end
  return str:sub(startIndex, currentIndex - 1)
end

data=activity.getSharedData(activity.getIntent().getStringExtra("table")) or nil
if(tostring(data)~="false" && tostring(data)~="null")then
  data=JSON.decode(data)
  adpData={}
  for _,v in pairs(data) do
    table.insert(adpData,{
      title={
        Text=v.title,
      },
      content={
        Text=utf8sub(v.content,0,32),
      }
    })
  end

  item={
    LinearLayout,
    layout_width="match",
    layout_height="wrap",
    {
      MaterialCardView,
      id="dataCard",
      layout_margin="4dp",
      layout_width="match",
      layout_height="wrap",
      cardBackgroundColor=activity.uiManager.getColors().colorPrimary,--卡片背景色
      cardElevation="0dp",--卡片阴影强度
      radius="8dp",--卡片圆角幅度
      {
        LinearLayout,
        layout_width="match",
        layout_height="wrap",
        padding="12dp",
        orientation="vertical",
        {
          TextView,
          id="title",
          layout_width="wrap",
          textSize="18sp",
          textColor=activity.uiManager.getColors().textColorPrimary,
        },
        {
          TextView,
          id="content",
          layout_marginTop="8dp",
          layout_width="wrap",
          textSize="14sp",
          textColor=activity.uiManager.getColors().textColorSecondary,
        },
        {LinearLayout,
          layout_width="match",
          layout_marginTop="8dp",
          orientation="horizontal",
          gravity="end",
          {
            TextView,
            id="tag",
            textSize="12sp",
            textColor=activity.uiManager.getColors().textColorSecondary,
          }
        },
      },
    },
  }

  list.layoutManager=LinearLayoutManager(activity)
  list.Adapter=LuaRecyclerAdapter(activity,adpData,item)
  list.Adapter.clickViewId="dataCard"
  list.Adapter.onItemClick=function(adapter,itemView,view,pos)
    local bundle=Bundle()
    bundle.putString("data",tostring(data[pos+1].content))
    activity.startFusionActivity("viewer",bundle)
    return true
  end
  --[[list.Adapter.onItemLongClick=function(adapter,itemView,view,pos)
    pop=PopupMenu(activity,view)
    menu=pop.Menu
    menu.add("分享正文").onMenuItemClick=function(a)
      print("🌚开发中")
    end
    pop.show()
  end]]
 else
   istEmpty.visibility=0
end