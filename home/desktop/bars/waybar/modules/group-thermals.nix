{
  lib,
  host ? { },
}:
let
  isAmd = (host.gpu or "generic") == "amd";
  hasNvme = host.hasNvme or false;

  modules = [
    "custom/thm-cpu"
    "custom/bullet"
  ]
  ++ lib.optionals isAmd [
    "custom/thm-amd"
    "custom/bullet"
  ]
  ++ lib.optionals hasNvme [
    "custom/thm-nvme"
    "custom/bullet"
  ]
  ++ [
    "custom/thm-amb"
    "custom/separator"
  ]
  ++ lib.optionals isAmd [
    "custom/thm-pwr"
    "custom/bullet"
  ]
  ++ [
    "custom/thm-batv"
    "custom/bullet"
    "custom/thm-bati"
    "custom/separator"
    "custom/thm-fan"
  ];
in
{
  waybarModules = {
    "group/thermals" = {
      orientation = "horizontal";
      inherit modules;
      drawer = {
        trigger = "hover";
      };
    };
  };
}
