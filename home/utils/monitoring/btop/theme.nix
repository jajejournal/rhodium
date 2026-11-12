{ ... }:
{
  # btop is a TUI, so it follows Kanso (same palette as kitty/ghostty/foot).
  programs.btop.themes = {
    kanso = ''
      # Main background, empty for terminal default, need to be empty if you want transparent background
      theme[main_bg]="#090E13"

      # Main text color
      theme[main_fg]="#C5C9C7"

      # Title color for boxes
      theme[title]="#C5C9C7"

      # Highlight color for keyboard shortcuts
      theme[hi_fg]="#7FB4CA"

      # Background color of selected item in processes box
      theme[selected_bg]="#22262D"

      # Foreground color of selected item in processes box
      theme[selected_fg]="#7FB4CA"

      # Color of inactive/disabled text
      theme[inactive_fg]="#5C6066"

      # Color of text appearing on top of graphs, i.e uptime and current network graph scaling
      theme[graph_text]="#A4A7A4"

      # Background color of the percentage meters
      theme[meter_bg]="#22262D"

      # Misc colors for processes box including mini cpu graphs, details memory graph and details status text
      theme[proc_misc]="#A4A7A4"

      # CPU, Memory, Network, Proc box outline colors
      theme[cpu_box]="#938AA9"
      theme[mem_box]="#87A987"
      theme[net_box]="#E46876"
      theme[proc_box]="#7FB4CA"

      # Box divider line and small boxes line color
      theme[div_line]="#22262D"

      # Temperature graph color
      theme[temp_start]="#87A987"
      theme[temp_mid]="#E6C384"
      theme[temp_end]="#E46876"

      # CPU graph colors
      theme[cpu_start]="#7AA89F"
      theme[cpu_mid]="#7FB4CA"
      theme[cpu_end]="#938AA9"

      # Mem/Disk free meter
      theme[available_start]="#B98D7B"
      theme[available_mid]="#C4B28A"
      theme[available_end]="#E6C384"

      # Mem/Disk cached meter
      theme[cached_start]="#7FB4CA"
      theme[cached_mid]="#7AA89F"
      theme[cached_end]="#87A987"

      # Mem/Disk used meter
      theme[used_start]="#87A987"
      theme[used_mid]="#7AA89F"
      theme[used_end]="#7FB4CA"

      # Download graph colors
      theme[download_start]="#B98D7B"
      theme[download_mid]="#C4B28A"
      theme[download_end]="#E6C384"

      # Upload graph colors
      theme[upload_start]="#87A987"
      theme[upload_mid]="#7AA89F"
      theme[upload_end]="#7FB4CA"

      # Process box color gradient for threads, mem and cpu usage
      theme[process_start]="#7FB4CA"
      theme[process_mid]="#938AA9"
      theme[process_end]="#A4A7A4"
    '';
  };
}
