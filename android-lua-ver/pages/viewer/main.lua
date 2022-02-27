require"import"
import "android.widget.*"
import "android.view.WindowManager"
import "net.fusionapp.core.ui.adapter.BasePagerAdapter"
import "layout"

UiManager=this.UiManager
local viewPager=UiManager.viewPager
local list=ArrayList()
list.add(loadlayout(layout))
viewPager.setAdapter(BasePagerAdapter(list))

data=activity.getIntent().getStringExtra("data")
webView.loadData(data,"text/html","gb2312")