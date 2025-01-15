import os
import shutil
import sys
import platform
import argparse

def main():

	# change this depending on what game we're working with
	game_name = "gh3"
	data_folder_name = "deluxe"
	pak_file_name = "gh3dx"

	# accept platform arg
	parser = argparse.ArgumentParser(prog="configure")
	parser.add_argument("platform")
	args = parser.parse_args()

	# define extensions to rename and move everything in its place later
	# i'd rather not do this but eh, if any yas can find a better way to do this lmk - luna
	platform_extensions = {
		"pc": "xen",
		"xbox": "xen",
		"ps3": "ps3",
		"ps2": "ps2",
		"wii": "ngc"
	}
	plat_extension = platform_extensions[args.platform]

	# define platform and out paths
	platform_dir = os.path.abspath(os.path.join("platform", args.platform))
	out_dir = os.path.abspath(os.path.join("out", args.platform))

	# account for platform folder differences
	match args.platform:
		case "ps2":
			pak_file_dir = os.path.join(out_dir, data_folder_name.lower())
		case "wii":
			pak_file_dir = os.path.join(out_dir, "files", data_folder_name.lower())
		case "ps3":
			pak_file_dir = os.path.join(out_dir, "PS3_GAME", "USRDIR", "DATA", data_folder_name.upper())
		case _:
			pak_file_dir = os.path.join(out_dir, "DATA", data_folder_name.upper())

	# create output dirs
	os.makedirs(pak_file_dir, exist_ok=True)

	# copy platform files
	for item in os.listdir(platform_dir):
		platform_item = os.path.join(platform_dir, item)
		dest_item = os.path.join(out_dir, item)
		if os.path.isdir(platform_item):
			shutil.copytree(platform_item, dest_item, dirs_exist_ok=True)
		else:
			shutil.copy2(platform_item, dest_item)

	# compile q scripts to qb and build pak file using honeycomb
	command = f"{os.path.abspath(os.path.join("dependencies", platform.system(), "Honeycomb-CLI", "Honeycomb"))} pak compile {os.path.abspath('_qb')} -g {game_name} -c {args.platform}"
	os.system(command)

	# rename and move new pak file
	built_pak_file = os.path.abspath(os.path.join(f"_qb.pak.{plat_extension}"))
	if os.path.exists(built_pak_file):
		full_pak_file_name = pak_file_name + ".pak." + plat_extension  # this is why we set the extension earlier
		# capitalize pak file name on ps3 because fuck you thats why
		if args.platform == "ps3":
			full_pak_file_name = full_pak_file_name.upper()
		shutil.move(built_pak_file, os.path.join(pak_file_dir, full_pak_file_name))
	else:
		print("\nBuild failed! :(")
		sys.exit(1)

main()
