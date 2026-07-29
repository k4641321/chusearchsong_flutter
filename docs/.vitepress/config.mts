import { text } from 'node:stream/consumers'
import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  base: '/chusearchsong_flutter/',
  title: "chusearchsong_flutter Docs",
  description: "chusearchsong(中二查歌) 帮助文档",
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: '主页', link: '/' },
      { text: '帮助文档', link: 'helper/index' }
    ],

    sidebar: [
      {
        text: '帮助文档',
        items: [
          { text: '主页', link: '/helper/' },
          {
            text: '功能介绍', link: '/helper/function/', items: [
              { text: '搜索歌曲', link: '/helper/function/search/' },
              { text: '歌曲详情', link: '/helper/function/songinfo/' },
              { text: '收藏', link: '/helper/function/favorite/' },
              {
                text: '工具', link: '/helper/function/tools/', items: [
                  { text: '等级划分与判定', link: '/helper/function/tools/rankinfo/' },
                  { text: 'Rating颜色', link: '/helper/function/tools/ratingcolor/' },
                  { text: '机厅搜索', link: '/helper/function/tools/searchlobby/' },
                  { text: '收藏品查询', link: '/helper/function/tools/searchcollectibles/' },
                  { text: 'Rating趋势', link: '/helper/function/tools/rattingtrend/' },
                  { text: '玩家信息', link: '/helper/function/tools/playerinfo/' },
                  { text: '单曲Rating计算器', link: '/helper/function/tools/ratingcalculator/' },
                  { text: '分数计算', link: '/helper/function/tools/scorecalculation/' },
                  { text: '容错计算', link: '/helper/function/tools/faulttoterantcomputation/' },
                  { text: 'B50生成', link: '/helper/function/tools/generateb50/' },
                  { text: '随机歌曲', link: '/helper/function/tools/randommusic/' },
                  { text: '更新成绩', link: '/helper/function/tools/updatescore/' },
                  { text: '歌曲推荐', link: '/helper/function/tools/songrecommendation/' },
                  { text: '等级完成进度', link: '/helper/function/tools/levelcompletionprogress/' },
                ]
              },
            ]
          }
        ]
      }
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/k4641321/chusearchsong_flutter' }
    ]
  }
})
