// ===========================================================================
// [IWAC] IBEN WAI AUTOCLAIM >> customsettings.sqf
// ===========================================================================
// [last update: 2018-01-13]
// ===========================================================================
// created by @iben for WAI, DayZ Epoch 1.0.6.2
// ===========================================================================
if (isServer) then {
  // -------------------------------------------------------------------------
  // :: WAI root path autofinder: Do not remove it!
   #include "addons\IWAC\IBEN_fnc_init_ROOTer.sqf"
  WAIROOT = ["customsettings.sqf",__FILE__,true,false] call IBEN_fnc_init_ROOTer;
  if (isNil "WAIROOT") exitWith { /* See RPT log */ };

  // -------------------------------------------------------------------------
  // :: Turn ON/OFF addon
  iben_wai_ACuseAddon = true;

  // -------------------------------------------------------------------------
  // :: Exclude missions by type from autoclaiming:
  // :: For some mission types you want to have IWAC disabled (you don't want to
  // :: run autoclaim system for moving vehicle patrols for example). This option
  // :: could be also usefull for some special mission type you've created and
  // :: you wish them to be free for all anytime.
  // :: If you add your type into bellow array, autoclaim system will respect
  // :: your desicion and will be disabled.
  // :: Recommended: Leave "patrol" mission type included as bellow:
  iben_wai_ACexcludedTypes = ["patrol"];

  // -------------------------------------------------------------------------
  // >> In what distance should autoclaim happen?
  // >> Remember, distance is valid for 'z' axis too (air vehicles)
  iben_wai_ACdistance = 1200;

  // -------------------------------------------------------------------------
  // :: Set delay before system adds player to register when crosses claiming zone
  //    >> Important for just passing by players
  iben_wai_ACsafeClaimDelay = 60;

  // -------------------------------------------------------------------------
  // >> How long should claiming right be reserved for player outside zone or dead,
  //    disconnected etc?
  // >> If you don't want to use timeout, just set to 0 and claiming right will
  //    be free immediately when player is gone...
  // >> If there is no timeout and player is in zone, status is "Active"
  // >> Remember, timeout countdown is dynamic (updated on map in real time)
  // >> IMPORTANT: If 'iben_wai_ACdistance' > 'wai_timeout_distance', mission
  //    could dissappear no matter player has claimed it or not - choose distance
  //    wisely...
  iben_wai_ACtimeout = 300;

  // -------------------------------------------------------------------------
  // :: Admin suport (static solution for general use)
  // :: List your admins to be invisible to system.
  // :: If you want to be able switch admin status on/off dynamically, you need
  // :: to adjust your files separately (not supported by default for now...)
  iben_wai_ACexcludeAdmins = false;
  iben_wai_ACadmins = ["0","0"];

  // -------------------------------------------------------------------------
  // :: Should be players inside plotpole area excluded from register?
  // :: If true, player is dynamically checked - so if mission is running
  // :: and player is inside area 'iben_wai_ACplotRange', this could happen:
  // :: - Mission just spawned, plotpole is inside claiming zone OR outside
  // ::   and 'iben_wai_ACplotRange' range goes into claiming zone:
  // ::   * Player was inside plotpole zone:
  // ::     - Nothing -> player is not included to register process
  // ::   * Player goes outside plotpole zone and back:
  // ::     - Nothing unless:
  // ::       + 'iben_wai_ACsafeClaimDelay' is off, player was in waiting list:
  // ::          -> if back to plotpole, player will be removed from waiting list
  // ::       + player already claimed mission:
  // ::         -> it's like player left the claiming zone - timeout is fired.
  // ::            If timeout is off, claimer is removed.
  // :: Because there is 'iben_wai_ACsafeClaimDelay', players leaving bases will
  // :: have enough time safely move behind the claiming zone without being
  // :: noticed by claiming system (if you set the reasonable delay...)
  iben_wai_ACplotRestriction = true;

  // :: What distance from plotpole is not allowed?
  iben_wai_ACplotRange = (DZE_PlotPole select 0);

  // -------------------------------------------------------------------------
  // >> Should server sent private msg to player? (Other playes will not see it...)
  //    Msgs: (1) When player claims mission, (2) when timeout is triggered,
  //    (3) when player returns back to zone and timeout is stopped
  iben_wai_ACplayerMsg = true;

  // -------------------------------------------------------------------------
  // >> Do you want to show player name on map screen?
  //    If false, text "Claimed by a player [realtime status info]" will be used as default
  // >> Remember > works only if 'wai_radio_announce' is true and you have remote
  //    msgs installed!
  iben_wai_ACshowNames = true;

  // -------------------------------------------------------------------------
  // >> Do you want to see autoclaiming zone border on the screen map?
  iben_wai_ACzoneActivate = true;

  // >> If yes, you can choose color
  iben_wai_ACzoneMarkerColor = "ColorRed";

  // -------------------------------------------------------------------------
  // >> Choose marker type for A2/A2OA:
  //    see > https://community.bistudio.com/wiki/cfgMarkers
  iben_wai_ACmarkerType = "hd_flag";

  // >> Choose marker color
  iben_wai_ACmarkerColor = "ColorBlack";

  // >> Maximum distance from mission center for placing physical flag object
  //    - marker on map will follow that place.
  //    - Default minimum distance for random spot is 200m and 10m from nearest object
  iben_wai_ACmarkerRange = 400;

  // -------------------------------------------------------------------------
  // >> Flag (physicall object)
  // >> Should be created physical flag?
  iben_wai_ACcreateFlagOjb = true;

  // >> Single color: "FlagCarrierOPFOR_EP1" (red); "FlagCarrierINDFOR_EP1" (green);
  //    "FlagCarrierBLUEFOR_EP1" (blue); "FlagCarrierWhite_EP1" (white)
  // >> F1: "FlagCarrierChecked"
  // >> Remember, use "HeliHEmpty", if you don't want to use physical object (will be hidden)
  iben_wai_ACmarkerFlagClass = "FlagCarrierINDFOR_EP1";

  // -------------------------------------------------------------------------
  // >> Mission coordinates protector timer
  // >> This option is covering following WAI problem:
  //    Once mission was completed, mission marker in 'wai_mission_markers' array
  //    is immediately deleted. This could cause situation in which another (new)
  //    mission spawns at the same spot (...and player is still at the crate from
  //    previous mission) - reason: marker is no longer "protected" in find_position fnc.
  // >> When this situation could happen:
  //    Mostly if you are using static spawn points with lower number of static points
  //    and higher number of concurrent mission over the map. It's rare, but this issue
  //    was already reported before.
  //    -----------------------------
  // >> Set value to 0 if you don't want to use this kind of protection.
  //    -----------------------------
  // >> If you set value > 0 (in seconds), mission coordinates stays protected from another mission spawn
  //    in 'wai_avoid_missions' radius for given time in seconds.
  //    -----------------------------
  // >> Check is very performace friendly. It's applied only in case 'iben_wai_ACcoordProtectorTimer' > 0
  //    and 'iben_wai_ACprotectedCoord' array is not empy!
  // >> @for dev: this solution should stay as temp fix. This should be fixed in WAI core
  //    according to point of WAI repo owner view and dev plans.
  iben_wai_ACcoordProtectorTimer = 300; // @since v1.3

  // -------------------------------------------------------------------------
  // :: Recommended settings for WAI
  wai_mission_system = true;
  wai_avoid_missions = ((iben_wai_ACdistance * 2) + 500);
  wai_avoid_traders = (iben_wai_ACdistance + 200 + 500);
  wai_avoid_town = 0;
  wai_avoid_road = 0;
  wai_avoid_water = 50;
  wai_timeout_distance = iben_wai_ACdistance;

  // -------------------------------------------------------------------------
  // :: For dev only
  // -------------------------------------------------------------------------
  // :: Use debug log in RPT? (mostly you don't need it)
  iben_wai_ACdevmode = false;

  if (iben_wai_ACdevmode) then {
    wai_mission_timeout = [500,600];
    wai_mission_timer = [130,140];
    // :: find_position attempts limiter >> default 500.
    //    -----------------------------
    // :: If you will get RPT (server) info about reaching limit, think what
    //    needs to be done - (a) increase limit?; or (b) adjust values? (see RPT log which one)
    //    -----------------------------
    // :: There is no good general advice - depends on map, custom traders etc. That is why
    //    I set lower attemt 500 as default - to be sure you're warned in time about fact,
    //    WAI has to cycle hard to get mission spawn position.
    //    -----------------------------
    // :: IMPORTANT: If you reach default limit, current random spawn point processed by
    //    "find_position" fnc will be used as valid spot and mission will spawn in "overlapping mode"
    //    so you can see visualy somenthing went wrong. This situation is telling you:
    //    "WAI has to work hard to find valid spot for my next mission. Because I don't
    //    want to degrade my server performance, I should go to check server RPT - there is
    //    info for me, which values I'm suppose to consider to optimize my setup."
    //    For example (using static spawn points): you will see in server RPT:
    //    "=== [IBEN WAI AUTOCLAIM ADDON, v1.3.1] || DEBUG [find_position.sqf] >> You have reached max attempts (500) to find mission spawn point. Consider to adjust these variables: 'iben_wai_ACdistance', 'wai_avoid_missions', 'wai_avoid_traders', 'wai_avoid_town', 'wai_avoid_road' and 'wai_avoid_water'. Think about all traders, water, roads etc."
    //    -----------------------------
    // :: You can set 'iben_wai_ACdevmode' to true and adjust 'iben_waiACfindPosLimiter'
    //    for testing.
    iben_waiACfindPosLimiter = 500; // @since v1.3
  };

  // -------------------------------------------------------------------------
  // === :: [IWAC] IBEN WAI AUTOCLAIM >> CUSTOM SETTINGS (customsettings.sqf) ::END
  // -------------------------------------------------------------------------

  // ....

  // -------------------------------------------------------------------------
  WAIcustomConfigloaded = true;
};

// === :: [IWAC] IBEN WAI AUTOCLAIM >> customsettings.sqf :: END
