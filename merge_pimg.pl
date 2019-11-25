#!/usr/bin/perl
# merge_pimg.pl, 2019/11/25
# coded by asmodean
# changed by login256

# contact: 
#   web:   http://asmodean.reverse.net
#   email: asmodean [at] hush.com
#   irc:   asmodean on efnet (irc.efnet.net)

# contact:
# ahaloer@163.com

# This script merges layers extracted from PSB (*.pimg) composites used in CS-trial.
# Extract the composites and convert to PNG before using this.

die "usage: $0 <input+layers.txt>\n"
  unless ($#ARGV == 0);

$filename = $ARGV[0] =~ m@(.*)\+pimg\+layers@;
$prefix = $1;

sub get_value {
  $line = <>;
  
  if ($line =~ m@.*:\s*(\S+)@) {  
    return $1;
  } else {
    return "";
  }
}

$image_width  = get_value();
$image_height = get_value();
get_value();

while (1) {
  $name     = get_value();
  
  last unless $name;
  
  $layer_id = get_value();
  $width    = get_value();
  $height   = get_value();
  $left     = get_value();
  $top      = get_value();
  $opacity  = get_value();
  $layer_type = get_value();
  $type     = get_value();
  $visible  = get_value();
  
  while (get_value() ne "") {}

  $layers{$name}{"name"}      = $name;  
  $layers{$name}{"layer_id"}  = $layer_id;
  $layers{$name}{"width"}     = $width;
  $layers{$name}{"height"}    = $height;
  $layers{$name}{"left"}      = $left;
  $layers{$name}{"top"}       = $top;
}

for $name (keys(%layers)) {
  $layer_id   = $layers{$name}{"layer_id"};  
  $width  = $layers{$name}{"width"};
  $height = $layers{$name}{"height"};
  $left   = $layers{$name}{"left"};
  $top    = $layers{$name}{"top"};
  
  $base_name = $name;
  $base_name = substr($base_name, 0, 1)."a";

  #print $name;
  #print $base_name;

  if ($name ne $base_name) { 
    $base_layer_id   = $layers{$base_name}{"layer_id"};  
    $base_width  = $layers{$base_name}{"width"};
    $base_height = $layers{$base_name}{"height"};
    $base_left   = $layers{$base_name}{"left"};
    $base_top    = $layers{$base_name}{"top"};  

    #print $base_layer_id;

    system("convert",
           "-size", "${image_width}x${image_height}",
           "-page", "+${base_left}+${base_top}", "${prefix}+pimg+${base_layer_id}.png",
           "-page", "+${left}+${top}", "${prefix}+pimg+${layer_id}.png",
           "-mosaic",
           "${prefix}+${base_name}+${name}.png");
  } else {
    system("convert",
           "-size", "${image_width}x${image_height}",
           "-page", "+${left}+${top}", "${prefix}+pimg+${layer_id}.png",
           "-mosaic",
           "${prefix}+${name}.png");
  }
    
}
