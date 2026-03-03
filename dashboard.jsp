<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="true" %>
<%@ page import="com.setmygoal.model.Student" %>
<%
    Student student = (Student) session.getAttribute("student");
    if (student == null) { response.sendRedirect("login.html"); return; }
    String name         = student.getFullName()     != null ? student.getFullName()     : "Student";
    String firstName    = name.contains(" ") ? name.substring(0, name.indexOf(" ")) : name;
    String standard     = student.getStandard()     != null ? student.getStandard()     : "10th";
    String careerStream = student.getCareerStream() != null ? student.getCareerStream() : "NotSure";
    String interest     = student.getInterest()     != null ? student.getInterest()     : "";
    String board        = student.getBoard()        != null ? student.getBoard()        : "";
    String medium       = student.getMedium()       != null ? student.getMedium()       : "English";
    String prepLevel    = student.getPrepLevel()    != null ? student.getPrepLevel()    : "not_started";
    String goalTimeline = student.getGoalTimeline() != null ? student.getGoalTimeline() : "Not sure";
    String state        = student.getState()        != null ? student.getState()        : "";
    boolean isSchool = standard.equals("8th")||standard.equals("9th")||standard.equals("10th");
    boolean isHSC    = standard.startsWith("11th")||standard.startsWith("12th");
    boolean isGrad   = standard.startsWith("grad")||standard.equals("pg")||standard.equals("dropout");
    String prepLabel = "Haven't started";
    if(prepLevel.equals("just_started")) prepLabel="Just started";
    if(prepLevel.equals("in_progress"))  prepLabel="Preparing";
    if(prepLevel.equals("advanced"))     prepLabel="Seriously preparing";
    String aiCtx = "Name="+firstName+",Standard="+standard+",Board="+board
                 +",Stream="+careerStream+",Interest="+interest
                 +",PrepLevel="+prepLabel+",Timeline="+goalTimeline+",State="+state;
%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Dashboard – SetMyGoal</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<style>
:root{
  --accent:#4F8EF7;--accent2:#a259ff;--grad:linear-gradient(135deg,#4F8EF7,#a259ff);
  --green:#34d399;--orange:#fbbf24;--red:#f87171;
  --bg:#0d0f14;--bg2:#13161e;--bg3:#1a1e2a;
  --surface:#1e2330;--surface2:#252b3b;
  --border:rgba(255,255,255,0.07);
  --text:#f0f2f8;--text2:#8b92a8;--text3:#5a6180;
  --nav-bg:rgba(13,15,20,0.92);
}
[data-theme="light"]{
  --bg:#f4f6fb;--bg2:#edf0f7;--bg3:#e4e8f2;
  --surface:#fff;--surface2:#f0f3fa;
  --border:rgba(0,0,0,0.08);
  --text:#111827;--text2:#4b5563;--text3:#9ca3af;
  --nav-bg:rgba(244,246,251,0.95);
}
*{box-sizing:border-box;margin:0;padding:0;}
body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);min-height:100vh;padding-top:68px;transition:background .3s,color .3s;}
h1,h2,h3,h4,h5{font-family:'Sora',sans-serif;}

/* NAV */
.smg-nav{background:var(--nav-bg)!important;backdrop-filter:blur(18px);border-bottom:1px solid var(--border);padding:10px 0;}
.smg-brand{font-family:'Sora',sans-serif;font-size:1.2rem;font-weight:800;color:var(--text)!important;}
.smg-brand span{background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent;}
.nav-pill{display:flex;align-items:center;gap:9px;background:var(--surface);border:1px solid var(--border);border-radius:100px;padding:4px 14px 4px 5px;}
.nav-av{width:30px;height:30px;border-radius:50%;background:var(--grad);display:flex;align-items:center;justify-content:center;font-size:.75rem;font-weight:700;color:#fff;}
.nav-nm{font-size:.82rem;font-weight:600;}
.btn-th{background:var(--surface);border:1px solid var(--border);color:var(--text);width:34px;height:34px;border-radius:8px;display:flex;align-items:center;justify-content:center;cursor:pointer;transition:all .2s;}
.btn-out{background:transparent;border:1px solid var(--border);color:var(--text2);font-size:.82rem;padding:6px 14px;border-radius:8px;text-decoration:none;transition:all .2s;}
.btn-out:hover{border-color:var(--red);color:var(--red);}

/* PAGE */
.page{padding:28px 0 80px;}

/* WELCOME */
.wcard{background:var(--surface);border:1px solid var(--border);border-radius:20px;padding:26px 30px;margin-bottom:22px;position:relative;overflow:hidden;}
.wcard::before{content:'';position:absolute;top:-60px;right:-40px;width:220px;height:220px;background:radial-gradient(circle,rgba(79,142,247,.1),transparent 70%);border-radius:50%;}
.wcard::after{content:'';position:absolute;bottom:-50px;left:20%;width:160px;height:160px;background:radial-gradient(circle,rgba(162,89,255,.07),transparent 70%);border-radius:50%;}
.wi{position:relative;z-index:2;}
.wlbl{font-size:.7rem;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:var(--accent);margin-bottom:5px;}
.wtitle{font-size:clamp(1.2rem,2.5vw,1.7rem);font-weight:800;letter-spacing:-.5px;margin-bottom:6px;}
.wtitle .g{background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent;}
.wsub{font-size:.86rem;color:var(--text2);margin-bottom:14px;}
.pills{display:flex;flex-wrap:wrap;gap:7px;}
.pill{display:inline-flex;align-items:center;gap:5px;background:var(--bg2);border:1px solid var(--border);border-radius:100px;padding:4px 11px;font-size:.73rem;font-weight:500;color:var(--text2);}
.pill i{color:var(--accent);font-size:.72rem;}

/* STATS */
.scard{background:var(--surface);border:1px solid var(--border);border-radius:14px;padding:18px;height:100%;transition:all .2s;}
.scard:hover{border-color:rgba(79,142,247,.3);transform:translateY(-3px);}
.sico{width:38px;height:38px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:.95rem;margin-bottom:12px;}
.ib{background:rgba(79,142,247,.12);color:#4F8EF7;}
.ip{background:rgba(162,89,255,.12);color:#a259ff;}
.ig{background:rgba(52,211,153,.12);color:#34d399;}
.io{background:rgba(251,191,36,.12);color:#fbbf24;}
.sval{font-family:'Sora',sans-serif;font-size:1.4rem;font-weight:800;}
.slbl{font-size:.75rem;color:var(--text2);margin-top:2px;}

/* TABS */
.tab-nav{display:flex;gap:5px;background:var(--surface);border:1px solid var(--border);border-radius:14px;padding:5px;margin-bottom:22px;overflow-x:auto;}
.tab-nav::-webkit-scrollbar{height:3px;}
.tnb{display:flex;align-items:center;gap:6px;padding:9px 16px;border-radius:9px;border:none;background:transparent;color:var(--text2);font-size:.82rem;font-weight:600;font-family:'DM Sans',sans-serif;cursor:pointer;transition:all .2s;white-space:nowrap;flex-shrink:0;}
.tnb:hover{background:var(--bg2);color:var(--text);}
.tnb.active{background:var(--grad);color:#fff;box-shadow:0 4px 14px rgba(79,142,247,.25);}
.tnb i{font-size:.88rem;}
.tp{display:none;}
.tp.active{display:block;animation:fadeUp .3s ease;}
@keyframes fadeUp{from{opacity:0;transform:translateY(10px);}to{opacity:1;transform:translateY(0);}}

/* PANEL CARD */
.pc{background:var(--surface);border:1px solid var(--border);border-radius:18px;padding:26px;margin-bottom:16px;}
.slabel{font-size:.68rem;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:var(--accent);margin-bottom:7px;}
.stitle{font-size:1.05rem;font-weight:700;margin-bottom:3px;letter-spacing:-.3px;}
.ssub{font-size:.82rem;color:var(--text2);margin-bottom:18px;}

/* ROADMAP */
.rm-hdr{display:flex;align-items:center;gap:13px;margin-bottom:22px;}
.rm-ico{width:46px;height:46px;border-radius:13px;background:var(--grad);display:flex;align-items:center;justify-content:center;font-size:1.2rem;color:#fff;flex-shrink:0;}
.rm-ttl{font-size:1.05rem;font-weight:700;}
.rm-sub{font-size:.8rem;color:var(--text2);}
.tli{display:flex;gap:14px;}
.tll{display:flex;flex-direction:column;align-items:center;flex-shrink:0;width:34px;}
.tldot{width:34px;height:34px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:.75rem;font-weight:700;font-family:'Sora',sans-serif;}
.tldot.done{background:var(--green);color:#fff;}
.tldot.cur{background:var(--grad);color:#fff;box-shadow:0 0 0 4px rgba(79,142,247,.2);}
.tldot.pend{background:var(--surface2);color:var(--text3);border:2px solid var(--border);}
.tlln{width:2px;flex:1;min-height:20px;background:var(--border);margin:3px 0;}
.tlln.done{background:var(--green);}
.tlb{padding:3px 0 22px;flex:1;}
.tlt{font-size:.9rem;font-weight:700;margin-bottom:3px;}
.tlt.c{color:var(--accent);}
.tld{font-size:.78rem;color:var(--text2);line-height:1.6;margin-bottom:6px;}
.tlts{display:flex;flex-wrap:wrap;gap:5px;}
.tltag{font-size:.67rem;font-weight:600;padding:2px 9px;border-radius:100px;border:1px solid var(--border);color:var(--text3);background:var(--bg2);}
.tltag.a{border-color:rgba(79,142,247,.3);color:var(--accent);background:rgba(79,142,247,.07);}
.igrid{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-top:16px;}
@media(max-width:576px){.igrid{grid-template-columns:1fr;}}
.icard{background:var(--bg2);border:1px solid var(--border);border-radius:12px;padding:15px;transition:border-color .2s;}
.icard:hover{border-color:rgba(79,142,247,.3);}
.ict{font-size:.7rem;font-weight:700;color:var(--text3);text-transform:uppercase;letter-spacing:.8px;margin-bottom:5px;}
.icv{font-size:.86rem;color:var(--text);line-height:1.6;}
.sal{font-family:'Sora',sans-serif;font-size:1.05rem;font-weight:800;background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent;}
.echips{display:flex;flex-wrap:wrap;gap:7px;margin-top:10px;}
.echip{display:inline-flex;align-items:center;gap:5px;background:var(--surface2);border:1px solid var(--border);border-radius:9px;padding:7px 12px;font-size:.78rem;font-weight:600;color:var(--text);transition:all .2s;}
.echip:hover{border-color:var(--accent);color:var(--accent);}
.echip i{color:var(--accent);}
.clg-list{list-style:none;padding:0;margin:10px 0 0;}
.clg-list li{display:flex;align-items:center;gap:9px;padding:7px 0;border-bottom:1px solid var(--border);font-size:.83rem;color:var(--text2);}
.clg-list li:last-child{border-bottom:none;}
.clg-list li i{color:var(--accent);font-size:.72rem;}
.tipbox{background:rgba(79,142,247,.06);border:1px solid rgba(79,142,247,.18);border-radius:12px;padding:13px 16px;display:flex;gap:10px;align-items:flex-start;margin-top:16px;}
.tipbox i{color:var(--accent);flex-shrink:0;margin-top:2px;}
.tipbox p{font-size:.8rem;color:var(--text2);margin:0;line-height:1.6;}

/* TASKS */
.streak-bar{background:var(--bg2);border:1px solid var(--border);border-radius:14px;padding:18px 20px;margin-bottom:18px;display:flex;align-items:center;gap:16px;}
.s-fire{font-size:2rem;}
.s-num{font-family:'Sora',sans-serif;font-size:2.2rem;font-weight:800;background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent;}
.s-lbl{font-size:.8rem;color:var(--text2);}
.wdots{display:flex;gap:7px;margin-top:10px;}
.wd{width:32px;height:32px;border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:.68rem;font-weight:700;background:var(--surface2);color:var(--text3);border:1px solid var(--border);}
.wd.done{background:var(--green);color:#fff;border-color:var(--green);}
.wd.today{background:var(--grad);color:#fff;border-color:transparent;}
.tinput-row{display:flex;gap:9px;margin-bottom:16px;}
.tinput{flex:1;background:var(--bg2);border:1.5px solid var(--border);color:var(--text);border-radius:10px;padding:10px 13px;font-size:.87rem;font-family:'DM Sans',sans-serif;outline:none;transition:border-color .2s;}
.tinput:focus{border-color:var(--accent);}
.tinput::placeholder{color:var(--text3);}
.tcat{background:var(--bg2);border:1.5px solid var(--border);color:var(--text);border-radius:10px;padding:0 12px;font-family:'DM Sans',sans-serif;outline:none;font-size:.85rem;}
.btn-add{background:var(--grad);color:#fff;border:none;border-radius:10px;padding:10px 16px;font-weight:600;cursor:pointer;transition:opacity .2s;}
.btn-add:hover{opacity:.88;}
.tlist{display:flex;flex-direction:column;gap:9px;}
.titem{display:flex;align-items:center;gap:11px;background:var(--bg2);border:1px solid var(--border);border-radius:12px;padding:12px 15px;transition:all .2s;}
.titem:hover{border-color:rgba(79,142,247,.3);}
.titem.done-t{opacity:.5;}
.titem.done-t .ttxt{text-decoration:line-through;color:var(--text3);}
.tchk{width:22px;height:22px;border-radius:6px;border:2px solid var(--border);display:flex;align-items:center;justify-content:center;cursor:pointer;transition:all .2s;flex-shrink:0;}
.tchk.chk{background:var(--green);border-color:var(--green);color:#fff;}
.ttxt{flex:1;font-size:.87rem;}
.tcat-badge{font-size:.67rem;font-weight:700;padding:2px 8px;border-radius:100px;background:rgba(79,142,247,.1);color:var(--accent);}
.tdel{background:none;border:none;color:var(--text3);cursor:pointer;font-size:.88rem;padding:2px 4px;transition:color .2s;}
.tdel:hover{color:var(--red);}

/* AI CHAT */
.chatbox{background:var(--bg2);border:1px solid var(--border);border-radius:14px;height:400px;overflow-y:auto;padding:14px;margin-bottom:12px;display:flex;flex-direction:column;gap:11px;}
.chatbox::-webkit-scrollbar{width:4px;}
.chatbox::-webkit-scrollbar-thumb{background:var(--border);border-radius:2px;}
.msg{max-width:82%;padding:10px 13px;border-radius:12px;font-size:.85rem;line-height:1.6;animation:msgIn .2s ease;}
@keyframes msgIn{from{opacity:0;transform:translateY(5px);}to{opacity:1;transform:translateY(0);}}
.msg.user{background:var(--grad);color:#fff;margin-left:auto;border-bottom-right-radius:3px;}
.msg.ai{background:var(--surface2);color:var(--text);border-bottom-left-radius:3px;}
.msg.ai .mlbl{font-size:.67rem;font-weight:700;color:var(--accent);margin-bottom:3px;letter-spacing:.5px;}
.cinput-row{display:flex;gap:9px;}
.cinput{flex:1;background:var(--bg2);border:1.5px solid var(--border);color:var(--text);border-radius:10px;padding:10px 13px;font-size:.87rem;font-family:'DM Sans',sans-serif;outline:none;transition:border-color .2s;}
.cinput:focus{border-color:var(--accent);}
.cinput::placeholder{color:var(--text3);}
.btn-send{background:var(--grad);color:#fff;border:none;border-radius:10px;padding:10px 18px;font-weight:600;font-family:'DM Sans',sans-serif;cursor:pointer;transition:opacity .2s;white-space:nowrap;}
.btn-send:hover{opacity:.88;}
.btn-send:disabled{opacity:.4;cursor:not-allowed;}
.qchips{display:flex;flex-wrap:wrap;gap:6px;margin-bottom:11px;}
.qchip{background:var(--surface2);border:1px solid var(--border);border-radius:100px;padding:5px 12px;font-size:.75rem;font-weight:500;color:var(--text2);cursor:pointer;transition:all .2s;}
.qchip:hover{border-color:var(--accent);color:var(--accent);}

/* QUIZ */
.quiz-card{background:var(--bg2);border:1px solid var(--border);border-radius:14px;padding:22px;}
.qprog{display:flex;align-items:center;gap:12px;margin-bottom:18px;}
.qpbar{flex:1;height:6px;background:var(--surface2);border-radius:3px;overflow:hidden;}
.qpfill{height:100%;background:var(--grad);border-radius:3px;transition:width .4s ease;}
.qplbl{font-size:.78rem;font-weight:700;color:var(--accent);}
.qquestion{font-size:.97rem;font-weight:600;color:var(--text);margin-bottom:16px;line-height:1.5;}
.qopts{display:flex;flex-direction:column;gap:9px;}
.qopt{background:var(--surface);border:1.5px solid var(--border);border-radius:10px;padding:11px 15px;cursor:pointer;font-size:.87rem;color:var(--text);transition:all .2s;text-align:left;font-family:'DM Sans',sans-serif;}
.qopt:hover:not(:disabled){border-color:var(--accent);color:var(--accent);}
.qopt.correct{border-color:var(--green)!important;background:rgba(52,211,153,.1);color:var(--green)!important;}
.qopt.wrong{border-color:var(--red)!important;background:rgba(248,113,113,.1);color:var(--red)!important;}
.qopt:disabled{cursor:not-allowed;}
.qexplain{margin-top:12px;background:rgba(79,142,247,.06);border:1px solid rgba(79,142,247,.2);border-radius:10px;padding:11px 13px;font-size:.8rem;color:var(--text2);display:none;}
.btn-nq{background:var(--grad);color:#fff;border:none;border-radius:10px;padding:9px 20px;font-weight:600;font-family:'DM Sans',sans-serif;cursor:pointer;margin-top:14px;display:none;}
.btn-nq:hover{opacity:.88;}
.btn-gq{background:var(--grad);color:#fff;border:none;border-radius:10px;padding:10px 22px;font-weight:600;font-family:'DM Sans',sans-serif;cursor:pointer;transition:all .2s;}
.btn-gq:hover{opacity:.88;transform:translateY(-1px);}

/* STUDY PLAN */
.plan-week{background:var(--bg2);border:1px solid var(--border);border-radius:14px;overflow:hidden;margin-bottom:14px;}
.plan-day{display:flex;gap:14px;padding:13px 17px;border-bottom:1px solid var(--border);align-items:flex-start;transition:background .2s;}
.plan-day:last-child{border-bottom:none;}
.plan-day:hover{background:var(--surface2);}
.pd-lbl{font-family:'Sora',sans-serif;font-size:.7rem;font-weight:700;color:var(--accent);width:34px;flex-shrink:0;padding-top:2px;}
.pd-body{flex:1;}
.pd-title{font-size:.87rem;font-weight:600;margin-bottom:2px;}
.pd-desc{font-size:.77rem;color:var(--text2);}
.pd-tags{display:flex;flex-wrap:wrap;gap:5px;margin-top:5px;}
.pd-tag{font-size:.67rem;font-weight:600;padding:2px 8px;border-radius:100px;background:rgba(79,142,247,.1);color:var(--accent);border:1px solid rgba(79,142,247,.2);}
.pd-hrs{font-size:.7rem;color:var(--text3);margin-top:3px;}
.btn-gp{background:var(--grad);color:#fff;border:none;border-radius:10px;padding:10px 22px;font-weight:600;font-family:'DM Sans',sans-serif;cursor:pointer;transition:all .2s;}
.btn-gp:hover{opacity:.88;transform:translateY(-1px);}

/* LOADING DOTS */
.ldots{display:none;padding:14px;text-align:center;}
.ldots span{display:inline-block;width:7px;height:7px;border-radius:50%;background:var(--accent);margin:0 2px;animation:bounce .9s infinite;}
.ldots span:nth-child(2){animation-delay:.2s;}
.ldots span:nth-child(3){animation-delay:.4s;}
@keyframes bounce{0%,60%,100%{transform:translateY(0);}30%{transform:translateY(-8px);}}

/* REVEAL */
.rv{opacity:0;transform:translateY(16px);transition:opacity .5s,transform .5s;}
.rv.vis{opacity:1;transform:translateY(0);}
</style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar smg-nav fixed-top">
  <div class="container d-flex align-items-center justify-content-between">
    <a class="smg-brand" href="dashboard">Set<span>My</span>Goal</a>
    <div class="d-flex align-items-center gap-2">
      <button class="btn-th" id="thBtn"><span id="thIco">🌙</span></button>
      <div class="nav-pill d-none d-md-flex">
        <div class="nav-av"><%= firstName.substring(0,1).toUpperCase() %></div>
        <span class="nav-nm"><%= firstName %></span>
      </div>
      <a href="logout" class="btn-out"><i class="bi bi-box-arrow-right me-1"></i>Logout</a>
    </div>
  </div>
</nav>

<div class="page">
<div class="container">

  <!-- WELCOME -->
  <div class="wcard rv">
    <div class="wi">
      <div class="wlbl">👋 Welcome back</div>
      <h1 class="wtitle">Hello, <span class="g"><%= firstName %>!</span> Your roadmap is ready.</h1>
      <p class="wsub">Personalized career guidance based on your profile. Use the tabs below to explore all features.</p>
      <div class="pills">
        <span class="pill"><i class="bi bi-mortarboard-fill"></i><%= standard %></span>
        <%if(!board.isEmpty()){%><span class="pill"><i class="bi bi-journal-bookmark-fill"></i><%= board %></span><%}%>
        <%if(!careerStream.equals("NotSure")){%><span class="pill"><i class="bi bi-compass-fill"></i><%= careerStream %></span><%}%>
        <%if(!interest.isEmpty()){%><span class="pill"><i class="bi bi-heart-fill"></i><%= interest %></span><%}%>
        <span class="pill"><i class="bi bi-bar-chart-fill"></i><%= prepLabel %></span>
        <%if(!goalTimeline.equals("Not sure")){%><span class="pill"><i class="bi bi-clock-fill"></i><%= goalTimeline %></span><%}%>
      </div>
    </div>
  </div>

  <!-- STATS -->
  <div class="row g-3 mb-4 rv">
    <div class="col-6 col-md-3"><div class="scard"><div class="sico ib"><i class="bi bi-map-fill"></i></div><div class="sval">1</div><div class="slbl">Active Roadmap</div></div></div>
    <div class="col-6 col-md-3"><div class="scard"><div class="sico ip"><i class="bi bi-lightning-charge-fill"></i></div><div class="sval" id="statStreak">0</div><div class="slbl">Day Streak 🔥</div></div></div>
    <div class="col-6 col-md-3"><div class="scard"><div class="sico ig"><i class="bi bi-check2-circle"></i></div><div class="sval" id="statTasks">0%</div><div class="slbl">Tasks Done Today</div></div></div>
    <div class="col-6 col-md-3"><div class="scard"><div class="sico io"><i class="bi bi-trophy-fill"></i></div><div class="sval"><%= goalTimeline.equals("Not sure")?"?":goalTimeline.split(" ")[0] %></div><div class="slbl">Goal Timeline</div></div></div>
  </div>

  <!-- TAB NAV -->
  <div class="tab-nav rv">
    <button class="tnb active" onclick="swTab('roadmap',this)"><i class="bi bi-map-fill"></i>Roadmap</button>
    <button class="tnb" onclick="swTab('tasks',this)"><i class="bi bi-check2-square"></i>Tasks & Streak</button>
    <button class="tnb" onclick="swTab('chat',this)"><i class="bi bi-robot"></i>AI Chat</button>
    <button class="tnb" onclick="swTab('quiz',this)"><i class="bi bi-patch-question-fill"></i>Quiz</button>
    <button class="tnb" onclick="swTab('plan',this)"><i class="bi bi-calendar3"></i>Study Plan</button>
  </div>

  <!-- ======= TAB: ROADMAP ======= -->
  <div id="tab-roadmap" class="tp active">

  <%-- SCIENCE / DOCTOR --%>
  <%if(careerStream.equals("Science")||interest.toLowerCase().contains("biology")||interest.toLowerCase().contains("medicine")||interest.toLowerCase().contains("doctor")){%>
  <div class="pc">
    <div class="rm-hdr"><div class="rm-ico">🏥</div><div><div class="rm-ttl">Doctor / Medical Professional</div><div class="rm-sub">MBBS · BDS · BAMS roadmap for <%= firstName %></div></div></div>
    <div class="tli"><div class="tll"><div class="tldot <%=isSchool?"cur":"done"%>"><%=isSchool?"→":"✓"%></div><div class="tlln <%=isSchool?"":"done"%>"></div></div><div class="tlb"><div class="tlt <%=isSchool?"c":""%>">9th & 10th — Foundation <%=isSchool?"← You are here":""%></div><div class="tld">Focus on PCB + Maths. Score 85%+. Start NCERT Biology reading early.</div><div class="tlts"><span class="tltag a">PCB Focus</span><span class="tltag">85%+ target</span><span class="tltag">NCERT</span></div></div></div>
    <div class="tli"><div class="tll"><div class="tldot <%=isHSC?"cur":(isSchool?"pend":"done")%>"><%=isHSC?"→":(isSchool?"2":"✓")%></div><div class="tlln <%=isHSC?"":(isSchool?"":"done")%>"></div></div><div class="tlb"><div class="tlt <%=isHSC?"c":""%>">11th & 12th — Science PCB <%=isHSC?"← You are here":""%></div><div class="tld">Take PCB. Join NEET coaching. Practice NCERT — NEET is 95% NCERT based.</div><div class="tlts"><span class="tltag a">NEET Prep</span><span class="tltag">Mock tests</span></div></div></div>
    <div class="tli"><div class="tll"><div class="tldot <%=isGrad?"cur":"pend"%>"><%=isGrad?"→":"3"%></div><div class="tlln"></div></div><div class="tlb"><div class="tlt">Crack NEET UG</div><div class="tld">Score 600+ for govt. college. Attempt every year till you crack it.</div><div class="tlts"><span class="tltag a">NEET UG</span><span class="tltag">600+ score</span></div></div></div>
    <div class="tli"><div class="tll"><div class="tldot pend">4</div><div class="tlln"></div></div><div class="tlb"><div class="tlt">MBBS — 5.5 Years</div><div class="tld">4.5 years study + 1 year mandatory internship. Govt. college saves fees.</div><div class="tlts"><span class="tltag">5.5 years</span><span class="tltag">Internship</span></div></div></div>
    <div class="tli"><div class="tll"><div class="tldot pend">5</div></div><div class="tlb"><div class="tlt">MD/MS Specialization</div><div class="tld">Crack NEET PG. Specialize in Cardiology, Ortho, Neurology for higher pay.</div><div class="tlts"><span class="tltag a">NEET PG</span><span class="tltag">Optional</span></div></div></div>
    <div class="slabel mt-3">Key Exams</div>
    <div class="echips"><div class="echip"><i class="bi bi-patch-check-fill"></i>NEET UG</div><div class="echip"><i class="bi bi-patch-check-fill"></i>NEET PG</div><div class="echip"><i class="bi bi-patch-check-fill"></i>AIIMS</div><div class="echip"><i class="bi bi-patch-check-fill"></i>State CET</div></div>
    <div class="igrid">
      <div class="icard"><div class="ict">📈 Market Scope</div><div class="icv">India needs 2M+ more doctors. Massive shortage = very high demand. Urban & rural both need doctors urgently.</div></div>
      <div class="icard"><div class="ict">💰 Salary Range</div><div class="icv"><span class="sal">₹8L – ₹80L/yr</span><br><small style="color:var(--text3)">Junior doctor to specialist</small></div></div>
    </div>
    <div class="slabel mt-3">Top Colleges</div>
    <ul class="clg-list"><li><i class="bi bi-building"></i>AIIMS Delhi — India's #1 medical college</li><li><i class="bi bi-building"></i>AIIMS Mumbai, Nagpur, Pune</li><li><i class="bi bi-building"></i>Grant Medical College, Mumbai</li><li><i class="bi bi-building"></i>BJ Medical College, Pune</li><li><i class="bi bi-building"></i>Govt. Medical College in your state</li></ul>
    <div class="tipbox"><i class="bi bi-lightbulb-fill"></i><p><strong>Pro Tip for <%= firstName %>:</strong> NEET is 95% NCERT. Start reading Class 11-12 Biology NCERT from now — every chapter early is a head start over lakhs of students!</p></div>
  </div>
  <%}%>

  <%-- TECHNOLOGY --%>
  <%if(careerStream.equals("Technology")||interest.toLowerCase().contains("coding")||interest.toLowerCase().contains("tech")||interest.toLowerCase().contains("computer")||interest.toLowerCase().contains("engineer")){%>
  <div class="pc">
    <div class="rm-hdr"><div class="rm-ico">💻</div><div><div class="rm-ttl">Software Engineer / IT Professional</div><div class="rm-sub">B.Tech · BCA · MCA roadmap for <%= firstName %></div></div></div>
    <div class="tli"><div class="tll"><div class="tldot <%=isSchool?"cur":"done"%>"><%=isSchool?"→":"✓"%></div><div class="tlln <%=isSchool?"":"done"%>"></div></div><div class="tlb"><div class="tlt <%=isSchool?"c":""%>">9th & 10th <%=isSchool?"← You are here":""%></div><div class="tld">Focus on Maths. Learn Python (30 min/day free). Score 85%+ for PCM stream.</div><div class="tlts"><span class="tltag a">Python start</span><span class="tltag">85%+ Maths</span></div></div></div>
    <div class="tli"><div class="tll"><div class="tldot <%=isHSC?"cur":(isSchool?"pend":"done")%>"><%=isHSC?"→":(isSchool?"2":"✓")%></div><div class="tlln"></div></div><div class="tlb"><div class="tlt <%=isHSC?"c":""%>">11th & 12th — PCM + JEE <%=isHSC?"← You are here":""%></div><div class="tld">PCM stream. JEE coaching. Start DSA. Build 1-2 small projects on GitHub.</div><div class="tlts"><span class="tltag a">JEE Prep</span><span class="tltag">DSA</span><span class="tltag">Projects</span></div></div></div>
    <div class="tli"><div class="tll"><div class="tldot pend">3</div><div class="tlln"></div></div><div class="tlb"><div class="tlt">JEE / CET Entrance</div><div class="tld">JEE Main for NITs. JEE Advanced for IITs. MHT-CET for Maharashtra colleges.</div><div class="tlts"><span class="tltag a">JEE Main</span><span class="tltag">MHT-CET</span><span class="tltag">BITSAT</span></div></div></div>
    <div class="tli"><div class="tll"><div class="tldot pend">4</div><div class="tlln"></div></div><div class="tlb"><div class="tlt">B.Tech CS/IT — 4 Years</div><div class="tld">CS or IT branch. Focus: DSA + System Design + Web/AI/ML. Internships from 2nd year.</div><div class="tlts"><span class="tltag">4 years</span><span class="tltag">Internships</span><span class="tltag">GitHub profile</span></div></div></div>
    <div class="tli"><div class="tll"><div class="tldot pend">5</div></div><div class="tlb"><div class="tlt">Placement / Product Companies</div><div class="tld">IIT/NIT placements up to ₹50L+. FAANG needs strong DSA. Startups value skills.</div><div class="tlts"><span class="tltag a">FAANG</span><span class="tltag">Startups</span><span class="tltag">GATE (M.Tech)</span></div></div></div>
    <div class="slabel mt-3">Key Exams</div>
    <div class="echips"><div class="echip"><i class="bi bi-patch-check-fill"></i>JEE Main</div><div class="echip"><i class="bi bi-patch-check-fill"></i>JEE Advanced</div><div class="echip"><i class="bi bi-patch-check-fill"></i>MHT-CET</div><div class="echip"><i class="bi bi-patch-check-fill"></i>BITSAT</div><div class="echip"><i class="bi bi-patch-check-fill"></i>GATE</div></div>
    <div class="igrid">
      <div class="icard"><div class="ict">📈 Market Scope</div><div class="icv">IT sector growing 15%/yr. 1.5M engineers/year but top 10% get great jobs. Skills > degree matters in India.</div></div>
      <div class="icard"><div class="ict">💰 Salary Range</div><div class="icv"><span class="sal">₹4L – ₹1Cr+/yr</span><br><small style="color:var(--text3)">Fresher to FAANG senior engineer</small></div></div>
    </div>
    <div class="slabel mt-3">Top Colleges</div>
    <ul class="clg-list"><li><i class="bi bi-building"></i>IIT Bombay, Delhi, Madras, Kharagpur</li><li><i class="bi bi-building"></i>NIT Trichy, Warangal, Surathkal</li><li><i class="bi bi-building"></i>BITS Pilani, Goa, Hyderabad</li><li><i class="bi bi-building"></i>COEP, VIT, Manipal</li></ul>
    <div class="tipbox"><i class="bi bi-lightbulb-fill"></i><p><strong>Pro Tip for <%= firstName %>:</strong> Start coding today on LeetCode or HackerRank — 30 min/day. Companies hire based on skills, not just marks. Your GitHub profile is your resume!</p></div>
  </div>
  <%}%>

  <%-- GOVERNMENT --%>
  <%if(careerStream.equals("Government")||interest.toLowerCase().contains("upsc")||interest.toLowerCase().contains("ias")||interest.toLowerCase().contains("civil")){%>
  <div class="pc">
    <div class="rm-hdr"><div class="rm-ico">🏛️</div><div><div class="rm-ttl">Government Officer — IAS / IPS</div><div class="rm-sub">UPSC · MPSC · SSC roadmap for <%= firstName %></div></div></div>
    <div class="tli"><div class="tll"><div class="tldot <%=isSchool?"cur":"done"%>"><%=isSchool?"→":"✓"%></div><div class="tlln <%=isSchool?"":"done"%>"></div></div><div class="tlb"><div class="tlt <%=isSchool?"c":""%>">9th & 10th <%=isSchool?"← You are here":""%></div><div class="tld">Read newspaper daily (The Hindu). Build GK. Study NCERT History, Geography, Civics thoroughly.</div><div class="tlts"><span class="tltag a">Daily newspaper</span><span class="tltag">NCERT basics</span></div></div></div>
    <div class="tli"><div class="tll"><div class="tldot <%=isHSC?"cur":(isSchool?"pend":"done")%>"><%=isHSC?"→":(isSchool?"2":"✓")%></div><div class="tlln"></div></div><div class="tlb"><div class="tlt <%=isHSC?"c":""%>">11th & 12th — Any Stream <%=isHSC?"← You are here":""%></div><div class="tld">Arts preferred for UPSC. Continue newspaper. Join debate clubs. Build public speaking skills.</div><div class="tlts"><span class="tltag">Any stream</span><span class="tltag">Arts preferred</span></div></div></div>
    <div class="tli"><div class="tll"><div class="tldot pend">3</div><div class="tlln"></div></div><div class="tlb"><div class="tlt">Graduation — Any Degree</div><div class="tld">BA History/Political Science overlaps best. Start UPSC prep in final year. Maintain 60%+.</div><div class="tlts"><span class="tltag">BA/B.Com/B.Sc</span><span class="tltag">Optional subject</span></div></div></div>
    <div class="tli"><div class="tll"><div class="tldot pend">4</div></div><div class="tlb"><div class="tlt">Crack UPSC — Prelims → Mains → Interview</div><div class="tld">3-4 attempts average. 12-16 months dedicated study. Join test series. Make notes from Day 1.</div><div class="tlts"><span class="tltag a">UPSC Prelims</span><span class="tltag">Mains</span><span class="tltag">Interview</span></div></div></div>
    <div class="slabel mt-3">Key Exams</div>
    <div class="echips"><div class="echip"><i class="bi bi-patch-check-fill"></i>UPSC CSE</div><div class="echip"><i class="bi bi-patch-check-fill"></i>MPSC</div><div class="echip"><i class="bi bi-patch-check-fill"></i>SSC CGL</div><div class="echip"><i class="bi bi-patch-check-fill"></i>IBPS Banking</div><div class="echip"><i class="bi bi-patch-check-fill"></i>State PSC</div></div>
    <div class="igrid">
      <div class="icard"><div class="ict">📈 Market Scope</div><div class="icv">1000+ IAS vacancies/year. Lakhs apply. Job security, pension, power & social respect unmatched.</div></div>
      <div class="icard"><div class="ict">💰 Salary + Perks</div><div class="icv"><span class="sal">₹56K–₹2.5L/mo</span><br><small style="color:var(--text3)">+ Bungalow, car, allowances</small></div></div>
    </div>
    <div class="tipbox"><i class="bi bi-lightbulb-fill"></i><p><strong>Pro Tip for <%= firstName %>:</strong> Start The Hindu newspaper from TODAY — 20 min/day. Years of current affairs is your biggest UPSC advantage over others who start late!</p></div>
  </div>
  <%}%>

  <%-- COMMERCE --%>
  <%if(careerStream.equals("Commerce")||interest.toLowerCase().contains("ca")||interest.toLowerCase().contains("finance")||interest.toLowerCase().contains("commerce")||interest.toLowerCase().contains("account")){%>
  <div class="pc">
    <div class="rm-hdr"><div class="rm-ico">📊</div><div><div class="rm-ttl">CA / Finance / Commerce Professional</div><div class="rm-sub">CA · MBA Finance · Banking roadmap for <%= firstName %></div></div></div>
    <div class="tli"><div class="tll"><div class="tldot <%=isSchool?"cur":"done"%>"><%=isSchool?"→":"✓"%></div><div class="tlln <%=isSchool?"":"done"%>"></div></div><div class="tlb"><div class="tlt <%=isSchool?"c":""%>">10th — Decide Commerce <%=isSchool?"← You are here":""%></div><div class="tld">Score 60%+ in Maths to take Commerce with Maths in 11th. Keeps CA + MBA options open.</div><div class="tlts"><span class="tltag a">Maths important</span><span class="tltag">60%+ target</span></div></div></div>
    <div class="tli"><div class="tll"><div class="tldot <%=isHSC?"cur":(isSchool?"pend":"done")%>"><%=isHSC?"→":(isSchool?"2":"✓")%></div><div class="tlln"></div></div><div class="tlb"><div class="tlt <%=isHSC?"c":""%>">11th & 12th — Commerce + CA Foundation <%=isHSC?"← You are here":""%></div><div class="tld">Take Accounts, Economics, Business Studies. Register for CA Foundation in 11th itself. Attempt in 12th.</div><div class="tlts"><span class="tltag a">CA Foundation</span><span class="tltag">Commerce HSC</span></div></div></div>
    <div class="tli"><div class="tll"><div class="tldot pend">3</div><div class="tlln"></div></div><div class="tlb"><div class="tlt">CA Intermediate + 3yr Articleship</div><div class="tld">8 papers in 2 groups. 3 year articleship under CA firm. Practical training in auditing, taxation.</div><div class="tlts"><span class="tltag a">CA Inter</span><span class="tltag">Articleship</span><span class="tltag">8 papers</span></div></div></div>
    <div class="tli"><div class="tll"><div class="tldot pend">4</div></div><div class="tlb"><div class="tlt">CA Final — Chartered Accountant</div><div class="tld">~7% pass rate. 6 papers. Work in Big 4 (Deloitte, PwC, EY, KPMG) or own practice.</div><div class="tlts"><span class="tltag a">CA Final</span><span class="tltag">Big 4</span><span class="tltag">Own practice</span></div></div></div>
    <div class="slabel mt-3">Key Exams</div>
    <div class="echips"><div class="echip"><i class="bi bi-patch-check-fill"></i>CA Foundation</div><div class="echip"><i class="bi bi-patch-check-fill"></i>CA Intermediate</div><div class="echip"><i class="bi bi-patch-check-fill"></i>CA Final (ICAI)</div><div class="echip"><i class="bi bi-patch-check-fill"></i>CAT (MBA)</div><div class="echip"><i class="bi bi-patch-check-fill"></i>IBPS/SBI</div></div>
    <div class="igrid">
      <div class="icard"><div class="ict">📈 Market Scope</div><div class="icv">Every company needs CA for auditing & tax. GST era increased CA demand 3x. Big 4 hire thousands/year.</div></div>
      <div class="icard"><div class="ict">💰 Salary Range</div><div class="icv"><span class="sal">₹7L – ₹40L+/yr</span><br><small style="color:var(--text3)">Fresh CA to Finance Director</small></div></div>
    </div>
    <div class="tipbox"><i class="bi bi-lightbulb-fill"></i><p><strong>Pro Tip for <%= firstName %>:</strong> CA has only ~7% pass rate but that's because most don't plan early. Start CA Foundation prep in Class 11 — you'll have a full year advantage over others!</p></div>
  </div>
  <%}%>

  <%-- DEFAULT --%>
  <%if(careerStream.equals("NotSure")||careerStream.equals("Arts")||careerStream.equals("Law")||careerStream.equals("Defence")){%>
  <div class="pc">
    <div class="rm-hdr"><div class="rm-ico">🧭</div><div><div class="rm-ttl">Explore Your Career Path</div><div class="rm-sub">Use AI Chat to get your personalized roadmap!</div></div></div>
    <div class="tipbox" style="margin:0"><i class="bi bi-info-circle-fill"></i><p>Your stream is <strong>"<%= careerStream %>"</strong>. Click <strong>AI Chat</strong> above and ask: <em>"What career is best for me?"</em> — you'll get a fully personalized answer based on your profile!</p></div>
    <div class="echips mt-3"><div class="echip"><i class="bi bi-heart-fill"></i>Doctor (NEET)</div><div class="echip"><i class="bi bi-cpu-fill"></i>Engineer (JEE)</div><div class="echip"><i class="bi bi-building"></i>IAS (UPSC)</div><div class="echip"><i class="bi bi-graph-up"></i>CA (ICAI)</div><div class="echip"><i class="bi bi-shield-fill"></i>Defence (NDA)</div><div class="echip"><i class="bi bi-briefcase-fill"></i>Law (CLAT)</div></div>
  </div>
  <%}%>

  </div><!-- /tab-roadmap -->

  <!-- ======= TAB: TASKS & STREAK ======= -->
  <div id="tab-tasks" class="tp">
    <div class="pc">
      <div class="streak-bar">
        <div class="s-fire">🔥</div>
        <div>
          <div class="s-num" id="sNum">0</div>
          <div class="s-lbl">Day streak — keep it going!</div>
          <div class="wdots" id="wDots"></div>
        </div>
      </div>
      <div class="slabel">Today's Tasks</div>
      <div class="tinput-row">
        <input type="text" class="tinput" id="tInp" placeholder="Add a task e.g. 'Read NCERT Ch.3'...">
        <select class="tcat" id="tCat">
          <option value="Study">📚 Study</option>
          <option value="Practice">✏️ Practice</option>
          <option value="Revision">🔄 Revision</option>
          <option value="Mock Test">📝 Mock Test</option>
          <option value="Other">📌 Other</option>
        </select>
        <button class="btn-add" onclick="addTask()"><i class="bi bi-plus-lg"></i></button>
      </div>
      <div class="tlist" id="tList">
        <div style="text-align:center;padding:28px;color:var(--text3);font-size:.85rem;"><i class="bi bi-clipboard2-check" style="font-size:2rem;display:block;margin-bottom:8px;opacity:.4;"></i>No tasks yet — add your first task above!</div>
      </div>
    </div>
  </div>

  <!-- ======= TAB: AI CHAT ======= -->
  <div id="tab-chat" class="tp">
    <div class="pc">
      <div class="slabel">AI Career Assistant</div>
      <div class="stitle">Ask anything about your career</div>
      <p class="ssub">I know your full profile — ask specific questions for personalized answers.</p>
      <div class="qchips">
        <span class="qchip" onclick="quickSend(this)">What career suits me best?</span>
        <span class="qchip" onclick="quickSend(this)">How to prepare for <%= careerStream.equals("Science")?"NEET":careerStream.equals("Technology")?"JEE":careerStream.equals("Government")?"UPSC":careerStream.equals("Commerce")?"CA Foundation":"my entrance exam" %>?</span>
        <span class="qchip" onclick="quickSend(this)">Salary scope for <%= careerStream %> stream?</span>
        <span class="qchip" onclick="quickSend(this)">Give me a 30-day study plan</span>
        <span class="qchip" onclick="quickSend(this)">Top colleges for <%= careerStream %> stream</span>
      </div>
      <div class="chatbox" id="chatBox">
        <div class="msg ai"><div class="mlbl">SetMyGoal AI</div>Hi <%= firstName %>! 👋 I'm your personal career AI. I know you're a <strong><%= standard %></strong> student interested in <strong><%= careerStream.equals("NotSure")?interest:careerStream %></strong>. Ask me anything — career advice, exam tips, study strategies, salary info, or college recommendations!</div>
      </div>
      <div class="ldots" id="chatLoad"><span></span><span></span><span></span></div>
      <div class="cinput-row">
        <input type="text" class="cinput" id="cInp" placeholder="Ask anything about your career..." onkeydown="if(event.key==='Enter')sendChat()">
        <button class="btn-send" id="cSendBtn" onclick="sendChat()"><i class="bi bi-send-fill me-1"></i>Send</button>
      </div>
    </div>
  </div>

  <!-- ======= TAB: QUIZ ======= -->
  <div id="tab-quiz" class="tp">
    <div class="pc">
      <div class="slabel">Career Knowledge Quiz</div>
      <div class="stitle">Test your <%= careerStream %> knowledge</div>
      <p class="ssub">AI-generated quiz based on your career stream — exams, scope, eligibility & more.</p>
      <div id="quizStart" class="text-center py-4">
        <div style="font-size:3rem;margin-bottom:10px;">🎯</div>
        <p style="color:var(--text2);font-size:.88rem;margin-bottom:18px;">5 questions about <strong><%= careerStream %></strong> career path generated by AI.</p>
        <button class="btn-gq" onclick="genQuiz()"><i class="bi bi-play-fill me-1"></i>Start Quiz</button>
      </div>
      <div id="quizArea" style="display:none;">
        <div class="qprog"><div class="qpbar"><div class="qpfill" id="qpf" style="width:0%"></div></div><span class="qplbl" id="qplbl">Q 1/5</span></div>
        <div class="quiz-card">
          <div class="qquestion" id="qQ">Loading...</div>
          <div class="qopts" id="qOpts"></div>
          <div class="qexplain" id="qExp"></div>
          <button class="btn-nq" id="qNext" onclick="nextQ()">Next →</button>
        </div>
      </div>
      <div id="quizResult" style="display:none;" class="text-center py-4">
        <div style="font-size:3rem;margin-bottom:10px;" id="qREmo">🎉</div>
        <div style="font-family:'Sora',sans-serif;font-size:1.6rem;font-weight:800;background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent;" id="qRScore"></div>
        <p style="color:var(--text2);font-size:.88rem;margin:8px 0 18px;" id="qRMsg"></p>
        <button class="btn-gq" onclick="restartQuiz()"><i class="bi bi-arrow-repeat me-1"></i>Try Again</button>
      </div>
    </div>
  </div>

  <!-- ======= TAB: STUDY PLAN ======= -->
  <div id="tab-plan" class="tp">
    <div class="pc">
      <div class="slabel">AI Study Plan Generator</div>
      <div class="stitle">Your personalized weekly plan</div>
      <p class="ssub">AI creates a custom 7-day schedule based on your stream, prep level and goal.</p>
      <div class="d-flex gap-3 flex-wrap mb-3">
        <div><label style="font-size:.77rem;color:var(--text2);display:block;margin-bottom:5px;">Study hours/day</label>
        <select id="pHours" style="background:var(--bg2);border:1.5px solid var(--border);color:var(--text);border-radius:10px;padding:8px 13px;font-family:'DM Sans',sans-serif;outline:none;">
          <option value="1">1 hour</option><option value="2" selected>2 hours</option><option value="3">3 hours</option><option value="4">4+ hours</option>
        </select></div>
        <div><label style="font-size:.77rem;color:var(--text2);display:block;margin-bottom:5px;">Focus area</label>
        <select id="pFocus" style="background:var(--bg2);border:1.5px solid var(--border);color:var(--text);border-radius:10px;padding:8px 13px;font-family:'DM Sans',sans-serif;outline:none;">
          <option>Exam preparation</option><option>Concept building</option><option>Revision & practice</option><option>Mock tests</option>
        </select></div>
      </div>
      <button class="btn-gp" onclick="genPlan()"><i class="bi bi-calendar3 me-1"></i>Generate My Plan</button>
      <div class="ldots mt-3" id="planLoad"><span></span><span></span><span></span></div>
      <div id="planOut" class="mt-3"></div>
    </div>
  </div>

</div></div><!-- /container /page -->

<!-- Pass Java vars to JS -->
<script>
const CTX   = `<%= aiCtx %>`;
const STREAM= '<%= careerStream %>';
const SNAME = '<%= firstName %>';
const KEY   = 'smg_'+SNAME;
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
// ── THEME ──
const html=document.documentElement;
const th=localStorage.getItem('smg-theme')||'dark';
html.setAttribute('data-theme',th);
document.getElementById('thIco').textContent=th==='dark'?'🌙':'☀️';
document.getElementById('thBtn').addEventListener('click',()=>{
  const n=html.getAttribute('data-theme')==='dark'?'light':'dark';
  html.setAttribute('data-theme',n);
  document.getElementById('thIco').textContent=n==='dark'?'🌙':'☀️';
  localStorage.setItem('smg-theme',n);
});

// ── REVEAL ──
const ob=new IntersectionObserver(e=>e.forEach(x=>{if(x.isIntersecting){x.target.classList.add('vis');ob.unobserve(x.target);}}),{threshold:.08});
document.querySelectorAll('.rv').forEach(el=>ob.observe(el));

// ── TABS ──
function swTab(id,btn){
  document.querySelectorAll('.tp').forEach(p=>p.classList.remove('active'));
  document.querySelectorAll('.tnb').forEach(b=>b.classList.remove('active'));
  document.getElementById('tab-'+id).classList.add('active');
  btn.classList.add('active');
}

// ══════════════════════════
// TASKS & STREAK
// ══════════════════════════
let tasks=JSON.parse(localStorage.getItem(KEY+'_tasks')||'[]');
let streak=parseInt(localStorage.getItem(KEY+'_streak')||'0');
let lastDone=localStorage.getItem(KEY+'_lastdone')||'';
const today=new Date().toDateString();

function renderTasks(){
  const list=document.getElementById('tList');
  if(!tasks.length){
    list.innerHTML='<div style="text-align:center;padding:28px;color:var(--text3);font-size:.85rem;"><i class="bi bi-clipboard2-check" style="font-size:2rem;display:block;margin-bottom:8px;opacity:.4;"></i>No tasks yet!</div>';
    document.getElementById('statTasks').textContent='0%';
    return;
  }
  const done=tasks.filter(t=>t.done).length;
  const pct=Math.round((done/tasks.length)*100);
  document.getElementById('statTasks').textContent=pct+'%';
  list.innerHTML=tasks.map((t,i)=>`
    <div class="titem ${t.done?'done-t':''}">
      <div class="tchk ${t.done?'chk':''}" onclick="toggleTask(${i})">${t.done?'<i class="bi bi-check-lg" style="font-size:.72rem;"></i>':''}</div>
      <span class="ttxt">${t.text}</span>
      <span class="tcat-badge">${t.cat}</span>
      <button class="tdel" onclick="delTask(${i})"><i class="bi bi-trash3"></i></button>
    </div>`).join('');
  if(pct===100&&lastDone!==today){streak++;lastDone=today;saveStreak();}
  document.getElementById('sNum').textContent=streak;
  document.getElementById('statStreak').textContent=streak;
}

function addTask(){
  const inp=document.getElementById('tInp');
  const cat=document.getElementById('tCat').value;
  const txt=inp.value.trim();
  if(!txt)return;
  tasks.push({text:txt,cat:cat,done:false});
  localStorage.setItem(KEY+'_tasks',JSON.stringify(tasks));
  inp.value='';renderTasks();
}
function toggleTask(i){tasks[i].done=!tasks[i].done;localStorage.setItem(KEY+'_tasks',JSON.stringify(tasks));renderTasks();}
function delTask(i){tasks.splice(i,1);localStorage.setItem(KEY+'_tasks',JSON.stringify(tasks));renderTasks();}
function saveStreak(){localStorage.setItem(KEY+'_streak',streak);localStorage.setItem(KEY+'_lastdone',lastDone);}
document.getElementById('tInp').addEventListener('keydown',e=>{if(e.key==='Enter')addTask();});

function renderWeekDots(){
  const days=['M','T','W','T','F','S','S'];
  const ti=(new Date().getDay()+6)%7;
  document.getElementById('wDots').innerHTML=days.map((d,i)=>
    `<div class="wd ${i<ti?'done':''} ${i===ti?'today':''}">${d}</div>`).join('');
  document.getElementById('sNum').textContent=streak;
  document.getElementById('statStreak').textContent=streak;
}

// ══════════════════════════
// AI CHAT
// ══════════════════════════
let history=[];

async function sendChat(){
  const inp=document.getElementById('cInp');
  const msg=inp.value.trim();
  if(!msg)return;
  inp.value='';
  appendMsg(msg,'user');
  history.push({role:'user',content:msg});
  setLoad('chatLoad',true);
  document.getElementById('cSendBtn').disabled=true;
  try{
    const r=await fetch('ai',{method:'POST',headers:{'Content-Type':'application/json'},
      body:JSON.stringify({type:'chat',message:msg,context:CTX,history:history.slice(-6)})});
    const d=await r.json();
    const reply=d.reply||'Sorry, could not get a response. Please try again.';
    appendMsg(reply,'ai');
    history.push({role:'assistant',content:reply});
  }catch(e){appendMsg('Connection error. Make sure AIServlet is compiled and running.','ai');}
  setLoad('chatLoad',false);
  document.getElementById('cSendBtn').disabled=false;
}

function appendMsg(text,role){
  const box=document.getElementById('chatBox');
  const d=document.createElement('div');
  d.className='msg '+role;
  d.innerHTML=role==='ai'?`<div class="mlbl">SetMyGoal AI</div>${text}`:text;
  box.appendChild(d);box.scrollTop=box.scrollHeight;
}

function quickSend(el){
  document.getElementById('cInp').value=el.textContent;
  // switch to chat tab
  document.querySelectorAll('.tp').forEach(p=>p.classList.remove('active'));
  document.querySelectorAll('.tnb').forEach(b=>b.classList.remove('active'));
  document.getElementById('tab-chat').classList.add('active');
  document.querySelectorAll('.tnb')[2].classList.add('active');
  sendChat();
}

// ══════════════════════════
// QUIZ
// ══════════════════════════
let qs=[],cq=0,sc=0;

async function genQuiz(){
  document.getElementById('quizStart').style.display='none';
  document.getElementById('quizArea').style.display='block';
  document.getElementById('qQ').textContent='Generating questions with AI...';
  document.getElementById('qOpts').innerHTML='';
  try{
    const r=await fetch('ai',{method:'POST',headers:{'Content-Type':'application/json'},
      body:JSON.stringify({type:'quiz',context:CTX,stream:STREAM})});
    const d=await r.json();
    qs=d.questions||[];
    if(!qs.length)throw new Error('empty');
    cq=0;sc=0;showQ();
  }catch(e){document.getElementById('qQ').textContent='Could not generate quiz. Please try again.';}
}

function showQ(){
  if(cq>=qs.length){showResult();return;}
  const q=qs[cq];
  document.getElementById('qpf').style.width=(cq/qs.length*100)+'%';
  document.getElementById('qplbl').textContent=`Q ${cq+1}/${qs.length}`;
  document.getElementById('qQ').textContent=q.question;
  document.getElementById('qExp').style.display='none';
  document.getElementById('qNext').style.display='none';
  document.getElementById('qOpts').innerHTML=q.options.map((o,i)=>
    `<button class="qopt" onclick="ansQ(${i})">${o}</button>`).join('');
}

function ansQ(idx){
  const q=qs[cq];
  const btns=document.querySelectorAll('.qopt');
  btns.forEach(b=>b.disabled=true);
  btns[idx].classList.add(idx===q.correct?'correct':'wrong');
  btns[q.correct].classList.add('correct');
  if(idx===q.correct)sc++;
  const ex=document.getElementById('qExp');
  ex.textContent=q.explanation;ex.style.display='block';
  document.getElementById('qNext').style.display='inline-block';
}

function nextQ(){cq++;showQ();}

function showResult(){
  document.getElementById('quizArea').style.display='none';
  document.getElementById('quizResult').style.display='block';
  const pct=Math.round((sc/qs.length)*100);
  document.getElementById('qRScore').textContent=`${sc}/${qs.length} — ${pct}%`;
  document.getElementById('qREmo').textContent=pct>=80?'🏆':pct>=60?'👍':'💪';
  document.getElementById('qRMsg').textContent=pct>=80?'Excellent! You know your career path well!':pct>=60?'Good effort! Keep learning more.':'Keep studying — use AI Chat for help!';
}

function restartQuiz(){
  document.getElementById('quizResult').style.display='none';
  document.getElementById('quizStart').style.display='block';
}

// ══════════════════════════
// STUDY PLAN
// ══════════════════════════
async function genPlan(){
  const hours=document.getElementById('pHours').value;
  const focus=document.getElementById('pFocus').value;
  setLoad('planLoad',true);
  document.getElementById('planOut').innerHTML='';
  try{
    const r=await fetch('ai',{method:'POST',headers:{'Content-Type':'application/json'},
      body:JSON.stringify({type:'plan',context:CTX,hours:hours,focus:focus,stream:STREAM})});
    const d=await r.json();
    renderPlan(d.plan||[]);
  }catch(e){document.getElementById('planOut').innerHTML='<p style="color:var(--red)">Could not generate plan. Please try again.</p>';}
  setLoad('planLoad',false);
}

function renderPlan(days){
  if(!days.length){document.getElementById('planOut').innerHTML='<p style="color:var(--text2)">No plan generated.</p>';return;}
  document.getElementById('planOut').innerHTML=`
    <div class="slabel">Your 7-Day Study Plan</div>
    <div class="plan-week">
      ${days.map(d=>`
      <div class="plan-day">
        <div class="pd-lbl">${d.day}</div>
        <div class="pd-body">
          <div class="pd-title">${d.title}</div>
          <div class="pd-desc">${d.description}</div>
          <div class="pd-tags">${(d.topics||[]).map(t=>`<span class="pd-tag">${t}</span>`).join('')}</div>
          <div class="pd-hrs">⏱ ${d.hours}</div>
        </div>
      </div>`).join('')}
    </div>
    <div class="tipbox"><i class="bi bi-lightbulb-fill"></i><p>Consistency beats intensity — follow this for 4 weeks and you'll see real progress, ${SNAME}!</p></div>`;
}

// ── Helper ──
function setLoad(id,show){document.getElementById(id).style.display=show?'flex':'none';}

// ── Init ──
renderTasks();
renderWeekDots();
</script>
</body>
</html>
