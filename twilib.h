/* Last Modified: July 5, 2012. by Plemling138 */
/* twilib.h   ---   Twitter Library
   Copyright (C) 2012 Plemling138

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software Foundation,
   Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.  
*/

#ifndef _TWILIB_H_
#define _TWILIB_H_

#define RECV_BUF_SIZE 500
#define TWEET_BUF_SIZE 2000

#define MSG_POST "POST"
#define MSG_HTTP "HTTP/1.0"

#define OAUTH_CONSKEY   "oauth_consumer_key="
#define OAUTH_NONCE     "oauth_nonce="
#define OAUTH_SIG       "oauth_signature="
#define OAUTH_SIGMETHOD "oauth_signature_method="
#define OAUTH_TSTAMP    "oauth_timestamp="
#define OAUTH_VER       "oauth_version="
#define OAUTH_TOKEN     "oauth_token="
#define OAUTH_VERIFIER  "oauth_verifier="

#define VER_1_0   "1.0"
#define HMAC_SHA1 "HMAC-SHA1"
#define STATUS    "status="

#define REQUEST_TOKEN_URL "https://api.twitter.com/oauth/request_token"
#define ACCESS_TOKEN_URL  "https://api.twitter.com/oauth/access_token"
#define STATUS_UPDATE_URL "https://api.twitter.com/1/statuses/update.xml"

struct Twitter_consumer_token
{
  char *consumer_key;
  char *consumer_secret;
};

struct Twitter_request_token
{
  char *request_token;
  char *request_secret;
};

struct Twitter_access_token
{
  char *access_token;
  char *access_secret;
  char *user_id;
  char *screen_name;
  char *pin;
};

int Twitter_GetRequestToken(struct Twitter_consumer_token *c, struct Twitter_request_token *r);
int Twitter_GetAccessToken(struct Twitter_consumer_token *c, struct Twitter_request_token *r, struct Twitter_access_token *a);
int Twitter_UpdateStatus(struct Twitter_consumer_token *c, struct Twitter_access_token *a, char *status);

#endif
