#!/usr/bin/env python3
import i3ipc
import time

MAX_TILED = 3

i3 = i3ipc.Connection()


def on_window_new(i3, event):
    time.sleep(0.1)

    window_id = event.container.id
    tree = i3.get_tree()
    window = tree.find_by_id(window_id)

    if window is None:
        return

    workspace = window.workspace()

    if workspace is None:
        return

    tiled_windows = [w for w in workspace.leaves()
                     if not w.floating in ('user_on', 'auto_on')]

    if len(tiled_windows) > MAX_TILED:
        i3.command(
            f'[con_id={window_id}] floating enable, move position center')


i3.on(i3ipc.Event.WINDOW_NEW, on_window_new)
i3.main()
