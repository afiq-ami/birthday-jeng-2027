# Birthday Jeng — deployment starter

## Current status
The included `index.html` is the approved visual prototype. It still uses browser `localStorage` for demo state.
It is **not live-ready** until the frontend is wired to the backend endpoints and cross-device tests are completed.

## Recommended stack
- Hosting: Cloudflare Pages (static site)
- Database + server functions: Supabase (Postgres + Edge Functions)
- Repo: GitHub private repository

## Setup order
1. Create a private GitHub repository and upload `index.html` as the root file.
2. Create a Supabase project.
3. Run `supabase_schema.sql` in Supabase SQL Editor.
4. Create server-side Edge Functions (not yet included) for:
   - `verify-code` (hash/validate secret code; admin authentication)
   - `get-guest-state`
   - `save-description`
   - `save-rsvp` (atomic max 3 Plus-One capacity)
   - `draw-fortune` (atomic credits + global no-repeat)
   - `admin-guest-list`, `admin-edit`, `admin-delete`, `admin-reset`
5. Connect the frontend to those functions; remove client-side admin bypass and localStorage as authoritative storage.
6. Deploy the GitHub repo to Cloudflare Pages.
7. Set environment variables only in server-side settings; never expose service-role secrets in frontend.
8. Test with two different devices/browsers, all guest codes, NO/YES RSVP, three +1 claims, fourth claim blocked, Fortune credits, admin edit/delete/reset and export.
9. Only publish invite URL after security and tests pass.

## Event details
- Event: 30 Jan 2027, 9:00 PM
- Venue: Alibaba, M3 Mall
- RSVP deadline: 29 Jan 2027
- +1 cap: 3
- WhatsApp group: https://chat.whatsapp.com/G6lUosncWAE9rXVZGljDIW

## Important
This starter does not include live backend credentials, Edge Functions, or a deployment URL. Those require creating/configuring your accounts and deploying.
