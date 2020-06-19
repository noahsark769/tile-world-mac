#import "SDL.h"
#import "SDLMain.h"

static int    gArgc;
static char  **gArgv;

@interface SDLApplication : NSApplication
@end

@implementation SDLApplication
/* Invoked from the Quit menu item */
- (void)terminate:(id)sender
{
    /* Post a SDL_QUIT event */
    SDL_Event event;
    event.type = SDL_QUIT;
    SDL_PushEvent(&event);
}

/* invoked by any keypress - filter out things that aren't pressed with the command modifier */
- (void)sendEvent:(NSEvent *)anEvent
{
	if(NSKeyDown == [anEvent type] || NSKeyUp == [anEvent type])
	{
		if([anEvent modifierFlags]&NSCommandKeyMask)
			[super sendEvent: anEvent];
	}
	else 
		[super sendEvent: anEvent];
}
@end


/* The main class of the application, the application's delegate */
@implementation SDLMain

/* Called when the internal event loop has just started running */
- (void) applicationDidFinishLaunching: (NSNotification *) note
{
    int status;

    /* Set the working directory to the .app's parent directory */
	[[NSFileManager defaultManager] changeCurrentDirectoryPath: [[NSBundle mainBundle] resourcePath]];
	setenv("SDL_ENABLEAPPEVENTS", "1", 1);

    /* Hand off to main application code */
    status = SDL_main(gArgc, gArgv);

    /* We're done, thank you for playing */
    exit(status);
}

@end


#ifdef main
#  undef main
#endif


/* Main entry point to executable - should *not* be SDL_main! */
int main (int argc, char **argv)
{
    /* Copy the arguments into a global variable */
    int i;
    
    /* This is passed if we are launched by double-clicking */
    if ( argc >= 2 && strncmp (argv[1], "-psn", 4) == 0 ) {
        gArgc = 1;
    } else {
        gArgc = argc;
    }
    gArgv = (char**) malloc (sizeof(*gArgv) * (gArgc+1));
    assert (gArgv != NULL);
    for (i = 0; i < gArgc; i++)
        gArgv[i] = argv[i];
    gArgv[i] = NULL;

//    [SDLApplication poseAsClass:[NSApplication class]];
    [SDLApplication sharedApplication];
    NSApplicationMain(argc, argv);

    return 0;
}
