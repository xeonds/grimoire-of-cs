require"import"
import "com.google.android.material.card.MaterialCardView"
import "com.google.android.material.textfield.TextInputLayout"
import "android.widget.*"
import "android.view.WindowManager"

import "com.google.android.material.snackbar.Snackbar"
import "com.google.android.material.button.MaterialButton"
import "com.google.android.material.textfield.TextInputEditText"
import "android.graphics.Color"
import "net.fusionapp.core.ui.adapter.BasePagerAdapter"
import "layout"

local MaterialAlertDialogBuilder = luajava.bindClass "com.google.android.material.dialog.MaterialAlertDialogBuilder"
local viewPager=this.UiManager.viewPager
local list=ArrayList()
list.add(loadlayout(layout))
viewPager.setAdapter(BasePagerAdapter(list))

prefUtil={
  setData=function(string_name,sth_value,string_mode)
    activity.setSharedData(string_name,sth_value)
  end,
  setDataR=function(string_name,sth_value,string_mode)
    if activity.getSharedData(string_name)==nil then
      activity.setSharedData(string_name,sth_value)
    end
  end,
  getData=function(string_name,default_value)
    if activity.getSharedData(string_name) then
      return activity.getSharedData(string_name)
     else
      return default_value
    end
  end
}

settingItem={
  {--标题
    LinearLayout;
    Focusable=true;
    layout_width="fill";
    layout_height="wrap";

    {
      TextView;
      id="title";
      textSize="14sp";
      textColor=activity.uiManager.getColors().colorAccent;
      layout_marginTop="16dp";
      layout_marginLeft="16dp";
      layout_marginBottom="8dp";
    };
  };
  {--设置项(标题,简介)
    LinearLayout;
    layout_width="match",
    layout_height="wrap",
    padding="12dp",
    orientation="vertical";
    gravity="center_vertical";
    {
      TextView;
      id="subtitle";
      textSize="16sp";
      textColor=activity.uiManager.getColors().textColorPrimary;
      layout_marginLeft="16dp";
    };
    {
      TextView;
      id="message";
      layout_marginLeft="16dp";
      textSize="14sp";
      textColor=activity.uiManager.getColors().textColorSecondary;
    };
  };
  {--设置项(标题)
    LinearLayout;
    layout_width="match",
    layout_height="wrap",
    padding="12dp",
    gravity="center_vertical";
    {
      TextView;
      id="subtitle";
      textSize="16sp";
      textColor="#AA000000";
      layout_marginLeft="16dp";
      textColor=activity.uiManager.getColors().textColorPrimary;
    };
  };
  {--设置项(标题,简介,开关)
    LinearLayout;
    layout_width="match",
    layout_height="wrap",
    padding="12dp",
    {
      LinearLayout;
      orientation="vertical";
      layout_height="wrap";
      gravity="center_vertical";
      layout_weight="1";
      {
        TextView;
        layout_marginLeft="16dp";
        textSize="16sp";
        id="subtitle";
        textColor=activity.uiManager.getColors().textColorPrimary;
      };
      {
        TextView;
        id="message";
        layout_marginLeft="16dp";
        textColor=activity.uiManager.getColors().textColorSecondary;
        textSize="14sp";
      };
    };
    {
      Switch;
      clickable=false;
      Focusable=false;
      layout_marginRight="16dp";
      id="status";
    };
  };
  {--设置项(标题,开关)
    LinearLayout,
    layout_width="match",
    layout_height="wrap",
    padding="12dp",
    {
      TextView;
      id="subtitle";
      textSize="16sp";
      gravity="center_vertical";
      layout_weight="1";
      layout_height="wrap";
      layout_marginLeft="16dp";
      textColor=activity.uiManager.getColors().textColorPrimary;
    };
    {
      Switch;
      id="status";
      Focusable=false;
      clickable=false;
      layout_marginRight="16dp";
      textColor=activity.uiManager.getColors().textColorPrimary;
    };
  }
}

prefTable={
  {__type=1,
    title="应用设置",
  },
  {__type=2,
    subtitle="数据源",
    message="数据请求接口地址",
  },
  {__type=1,
    title="其他",
  },
  {__type=2,
    subtitle="关于",
    message="无聊之作",
  },
}

data={}
adp=LuaMultiAdapter(activity,data,settingItem)
for k,v in pairs(prefTable) do
  if prefTable[k].status ~= nil then
    prefTable[k].status.Checked=Boolean.valueOf(prefUtil.getData(prefTable[k].subtitle,false))
  end
end
for _,v in pairs(prefTable) do
  adp.add(v)
end
settingListView.setAdapter(adp)
settingListView.onItemClick=function(id,v,zero,one)
  switch(v.Tag.subtitle.text) do
   case "关于"
    MaterialAlertDialogBuilder(activity)
    .setTitle("关于软件")
    .setMessage("一个关于计算机科学的小册子")
    .setPositiveButton("确定",nil)
    .show()
   case "数据源"
    MaterialAlertDialogBuilder(activity)
    .setTitle("设置接口URL")
    .setView(loadlayout({LinearLayout;
      orientation="vertical";
      Focusable=true,
      FocusableInTouchMode=true,
      {TextView;
        id="Prompt",textSize="14sp",
        layout_marginTop="8dp";layout_width="70%w";
        layout_gravity="center",
        text="为空表示使用默认设置";
      };
      {EditText;
        id="edit",hint="输入";layout_marginTop="16dp",
        layout_width="70%w";layout_gravity="center",
        text=prefUtil.getData(v.Tag.subtitle.Text),
      }}))
    .setPositiveButton("保存",{onClick=function()
        prefUtil.setData(v.Tag.subtitle.Text,edit.text)
      end})
    .show()
    --[[default
    if v.Tag.status ~= nil then
      if v.Tag.status.Checked then
        data[one].status.Checked=false
       else
        data[one].status.Checked=true
      end
      prefUtil.setData(v.Tag.subtitle.Text,tostring(data[one].status.Checked))
      adp.notifyDataSetChanged()
    end]]
  end
end
