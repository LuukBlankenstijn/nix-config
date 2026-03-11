_: {
  accounts.calendar.accounts = {
    "google" = {
      primary = false;
      remote = {
        type = "caldav";
        userName = "luukblankenstijn@gmail.com";
        url = "https://apidata.googleusercontent.com/caldav/v2/luukblankenstijn@gmail.com/events/";
      };
      thunderbird = {
        readOnly = true;
        enable = true;
        profiles = [ "default" ];
      };
    };
    "uni" = {
      primary = false;
      remote = {
        type = "caldav";
        userName = "l.c.m.blankenstijn@student.tue.nl";
        url = "https://outlook.office365.com/dav/ad/v2/";
      };
      thunderbird = {
        readOnly = true;
        enable = true;
        profiles = [ "default" ];
      };
    };
  };
}
