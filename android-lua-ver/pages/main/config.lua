--UI configure

this.UiManager.drawerHeaderSecondaryTextView.typeface=Typeface.SERIF
this.UiManager.appBarLayout.getChildAt(0).getChildAt(0).getChildAt(0).getChildAt(1).getChildAt(1).typeface=Typeface.SERIF

--Layouts for components

item={LinearLayout,
  layout_width="match",
  layout_height="wrap",
  padding="8dp",
  {MaterialCardView,
    id="card",
    layout_width="match",
    layout_height="wrap",
    radius="8dp",
    elevation="0dp",
    cardBackgroundColor="#5AE1E1E1",
    {
      LinearLayout,
      layout_width="match",
      layout_height="wrap",
      padding="12dp",
      orientation="vertical",
      {TextView,
        id="title",
        textSize="16sp",
        textColor=this.UiManager.getColors().textColorPrimary,
      },
      {RecyclerView,
        id="itemList",
        layout_width="match",
      }
    }
  }
}

innerItem={LinearLayout,
  layout_width="match",
  layout_height="wrap",
  padding="8dp",
  {MaterialCardView,
    id="innerCard",
    layout_width="match",
    layout_height="wrap",
    radius="8dp",
    elevation="0dp",
    cardBackgroundColor="#5AE1E1E1",
    padding="12dp",
    {
      LinearLayout,
      layout_width="match",
      layout_height="wrap",
      padding="12dp",
      orientation="vertical",
      {TextView,
        id="text",
        textColor=this.UiManager.getColors().textColorSecondary,
      },
    }
  }
}