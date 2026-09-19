# Content Inventory

Source: https://quillin-thenextrightthing.com/ (captured 2026-09-18)
Raw copy: reference/current-site.html, reference/current-images/

## What the current site actually is

A **single page**. One long scroll, WordPress 6.8.8 + Astra theme + Spectra (UAGB)
blocks. There is no second page, no nav menu, no anchor links, no sitemap. Every
piece of content below lives in one vertical stack.

## Sections, top to bottom

| # | Section | Content | Verdict |
|---|---|---|---|
| 1 | Hero | Logo, H1 "Do The Next Right Thing", "Request a Quote" | Keep, rebuild. See defects. |
| 2 | Call/Text notice | "Call Us or Send Us a Text!" + ** ATTENTION ** block: need YEAR, MAKE, MODEL; VIN required for 2010+ | This is the seed of the tool. See 03-tool-spec. |
| 3 | Phone CTA | "Need A Repair? Let's Make It Happen!" + 214-586-7650 | Keep. Must become tappable. |
| 4 | About Us | "Black Owned and Family Operated", family story, Aria and Jacob Quillin, 10+ years, community/integrity values | Keep. Trim ~30%. Strong differentiator, currently buried mid-page. |
| 5 | Services | Intro line (any car/truck/18-wheeler) + 6 cards: Rock Chip Repair, Windshield/Back Glass Replacement, Door Glass Replacement, Power Window Repair, Specialty Glass/Parts, ADAS Calibrations | Keep all 6. Best content on the site. |
| 6 | Reviews | "Happy & Honest Customer Reviews" / "Check us out on Google!" + a 13-slide carousel | Keep the proof, kill the carousel. See defects. |
| 7 | Quillin Guarantee | 5 trust points: Mobile, Real Craftsmanship, Easy Insurance Help, No Stress Pricing, Fast Turnaround + LIFETIME WARRANTY ON INSTALLATION | Keep. Promote; this is high-value and sits near the bottom. |
| 8 | Contact | Phone (214) 586-7650 (calls & text), QuillinAutoGlass@gmail.com, home office Wylie, Texas | Keep. |
| 9 | Hours | Mon-Fri 8a-6p, Sat 8a-12p, Sun by appointment | Keep. |
| 10 | Payment | All major credit cards (processing fees apply), Cash, Zelle | Keep. |

## Defects worth naming

1. **"Request a Quote" is not a link.** It is an `<h5>` with no href, no button, no
   form behind it. The site's primary call to action does nothing.
2. **The phone number is not tappable.** Zero `tel:` links on the page. On a phone,
   a customer has to memorize or copy 214-586-7650 by hand.
3. **The email is not a link either.** No `mailto:`.
4. **No form anywhere.** Every lead has to arrive by the customer independently
   deciding to call or text.
5. **Reviews are a 13-slide image carousel** (screenshots), not text. Invisible to
   search engines, unreadable to screen readers, heavy, and nobody clicks 13 slides.
6. **No `<title>` tag.** The browser tab is blank. Search results will be too.
7. **No meta description.**
8. **3.1 MB of images** for one page, including a 1 MB PNG photo. Two of them are
   stock (iStock, Pexels) mixed in with their own real work photos.
9. **No navigation.** On a page this long, the only way to reach the hours is to
   scroll past everything.
10. **No service area stated.** "Home Office Location: Wylie, Texas" is the only
    geography on a site for a *mobile* business. A customer in Plano cannot tell
    whether Quillin comes to them.
11. **No insurance page.** "Easy Insurance Help" is one bullet, yet insurance is
    the single biggest question a windshield customer has.
12. Typo: "INSTALATION" should be "INSTALLATION".

## Facts to carry over verbatim

- Company: Quillin Auto Glass
- Owners: Aria and Jacob Quillin
- Tagline: Do The Next Right Thing
- Phone: (214) 586-7650, accepts calls and texts
- Email: QuillinAutoGlass@gmail.com
- Location: Wylie, Texas (home office), mobile service
- Hours: Mon-Fri 8 AM-6 PM / Sat 8 AM-12 PM / Sun by appointment
- Payment: major credit cards (processing fees applied), cash, Zelle
- Warranty: lifetime on installation
- Experience: 10+ years
- Positioning: Black owned, family operated
- Intake requirement: year, make, model; VIN also required for 2010 and newer

## Brand

- Logo: line-art car front in a green-to-orange gradient, script "Quillin",
  "Auto Glass" beneath. reference/current-images/New-Logo-no-background-*.png
- Green #2e6911
- Orange #e56813
- Type on the current site: Barlow

## Proposed navigation

The current site has none. Target for the rebuild, 5 items or fewer:

    Services | Insurance | About | Contact | [Get a Quote]

with Get a Quote as the persistent action, and the phone number always visible in
the header. Hours, payment, service area and guarantee fold into Contact and the
footer rather than earning top-level slots.
