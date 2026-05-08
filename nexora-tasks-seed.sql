-- ============================================================
-- NEXORA — FIXED SQL SETUP
-- Run this entire block in Supabase SQL Editor
-- ============================================================

-- ── 1. LEADERBOARD POLICY (fixed syntax) ──────────────────
-- Drop first if exists, then recreate safely
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'public'
      AND tablename  = 'profiles'
      AND policyname = 'Authenticated read profiles for leaderboard'
  ) THEN
    EXECUTE $policy$
      CREATE POLICY "Authenticated read profiles for leaderboard"
        ON public.profiles
        FOR SELECT
        TO authenticated
        USING (true)
    $policy$;
  END IF;
END
$$;

-- ── 2. SEED ALL TASKS ──────────────────────────────────────
-- Safe: only inserts tasks that don't already exist (by title)

INSERT INTO public.tasks
  (title, description, category, payout_usd, estimated_mins, slots_total, status)
SELECT v.title, v.description, v.category, v.payout_usd, v.estimated_mins, v.slots_total, v.status
FROM (VALUES

  -- ── SURVEYS ──
  (
    'Product Feedback Survey',
    'Share your opinions on everyday consumer products for a UK market research firm. Quick 10-question form.',
    'survey', 0.80, 8, 500, 'active'
  ),
  (
    'Health & Lifestyle Survey',
    'Answer 15 questions about your daily health and wellness habits. For a global pharmaceutical company.',
    'survey', 1.20, 12, 400, 'active'
  ),
  (
    'Food Preference Research',
    'Tell us what you eat, when, and why. A food and beverage brand needs African consumer insights.',
    'survey', 0.90, 10, 400, 'active'
  ),
  (
    'Finance Habits Survey',
    'Questions about how you save, spend, and borrow money. For a fintech company building for Africa.',
    'survey', 1.50, 14, 300, 'active'
  ),
  (
    'Social Media Usage Study',
    'How do you use Instagram, TikTok, and X? A digital agency wants your honest answers.',
    'survey', 0.80, 8, 500, 'active'
  ),
  (
    'E-commerce Shopping Survey',
    'Tell us about your online shopping habits — what you buy, where, and why. For a leading African e-commerce brand.',
    'survey', 1.00, 10, 400, 'active'
  ),
  (
    'Political Awareness Poll',
    'Non-partisan questions about your awareness of local and national political issues. Anonymous survey.',
    'survey', 0.70, 7, 600, 'active'
  ),
  (
    'Transport and Mobility Study',
    'How do you get around your city? Ride-hailing, BRT, okada, or car? Research company needs data.',
    'survey', 0.90, 9, 400, 'active'
  ),
  (
    'Tech Product Opinions',
    'Rate and review 5 new smartphone features. No technical knowledge needed — just your honest opinion.',
    'survey', 1.20, 11, 350, 'active'
  ),
  (
    'Education Access Survey',
    'Share your experience with education in Nigeria — primary, secondary, or tertiary. Education nonprofit client.',
    'survey', 0.80, 8, 400, 'active'
  ),
  (
    'Entertainment Preferences',
    'Movies, music, streaming, gaming — what do you love? Media company wants Nigerian consumer data.',
    'survey', 0.60, 7, 600, 'active'
  ),
  (
    'Climate and Environment Poll',
    'Quick 8-question survey on your views about climate change and environmental practices in Nigeria.',
    'survey', 0.70, 7, 500, 'active'
  ),

  -- ── APP TESTING ──
  (
    'Android Banking App Test',
    'Test a new mobile banking app on Android. Check UI, navigation, and report any bugs. Detailed report required.',
    'app_testing', 2.50, 20, 150, 'active'
  ),
  (
    'iOS Social App Beta Test',
    'Download and test a new social app on iPhone. Use it for 10 minutes and submit a structured review.',
    'app_testing', 2.00, 18, 150, 'active'
  ),
  (
    'E-commerce Checkout Flow',
    'Walk through a checkout flow on a shopping app. Test cart, payment, and confirmation screens on Android.',
    'app_testing', 1.80, 15, 200, 'active'
  ),
  (
    'Food Delivery App UX Test',
    'Order a test meal on a new food delivery app (no real payment). Report usability issues and rate the experience.',
    'app_testing', 2.20, 18, 180, 'active'
  ),
  (
    'Fintech Onboarding Test',
    'Go through a fintech app onboarding flow from signup to first transaction. Report friction points clearly.',
    'app_testing', 3.00, 22, 120, 'active'
  ),
  (
    'Health App Navigation Test',
    'Navigate a health-tracking app and complete 5 specific tasks. Submit a screen recording or written report.',
    'app_testing', 2.50, 20, 130, 'active'
  ),
  (
    'Education Platform Review',
    'Explore a new e-learning app for 15 minutes. Rate clarity, speed, and content quality. Android or iOS.',
    'app_testing', 1.80, 16, 160, 'active'
  ),
  (
    'Ride-Hailing App Feedback',
    'Test a new ride-hailing app booking flow. No actual ride needed — test up to the driver assignment step.',
    'app_testing', 2.00, 14, 180, 'active'
  ),
  (
    'Crypto Wallet App Test',
    'Navigate a crypto wallet app through receiving, sending (test mode), and balance views. Report all bugs found.',
    'app_testing', 3.50, 25, 100, 'active'
  ),
  (
    'Marketplace App Bug Hunt',
    'Specifically hunt for bugs in a C2C marketplace app. Try edge cases — detailed bug reports rewarded.',
    'app_testing', 4.00, 28, 80, 'active'
  ),
  (
    'Android Dark Mode Audit',
    'Test the dark mode UI on an app across 8 screens. Note any colour contrast or visibility issues you find.',
    'app_testing', 1.50, 13, 200, 'active'
  ),
  (
    'Web App Cross-Browser Test',
    'Test a web application on Chrome, Firefox, and your phone browser. Check layout and functionality on each.',
    'app_testing', 2.80, 22, 120, 'active'
  ),

  -- ── DATA LABELING ──
  (
    'Image Label — 100 Products',
    'Label 100 product images with the correct category such as Electronics, Food, or Clothing. Fast repetitive task.',
    'data_labeling', 1.20, 18, 300, 'active'
  ),
  (
    'Sentiment Analysis — Tweets',
    'Mark 50 tweets as Positive, Negative, or Neutral. English and Pidgin tweets included. Fast task.',
    'data_labeling', 0.90, 12, 400, 'active'
  ),
  (
    'Audio Transcription 5 Min',
    'Transcribe a 5-minute audio clip in English. Accuracy is key. Good headphones are recommended.',
    'data_labeling', 3.00, 25, 150, 'active'
  ),
  (
    'Face Landmark Tagging',
    'Tag facial landmarks including eyes, nose, and mouth on 80 portrait images using our simple web tool.',
    'data_labeling', 1.80, 20, 200, 'active'
  ),
  (
    'Text Classification Batch',
    'Classify 60 customer support messages into categories: Billing, Technical, Complaint, or Praise. Fast task.',
    'data_labeling', 1.00, 14, 350, 'active'
  ),
  (
    'Map Location Verification',
    'Verify whether 40 business listings on a map are placed in the correct location. Google Maps knowledge helpful.',
    'data_labeling', 1.40, 16, 250, 'active'
  ),
  (
    'Offensive Content Review',
    'Review 50 social media posts and flag any that violate content policies. Clear guidelines are provided. 18+ only.',
    'data_labeling', 2.00, 18, 200, 'active'
  ),
  (
    'Receipt Data Extraction',
    'Extract merchant name, date, total amount, and items from 30 receipt images into a simple spreadsheet template.',
    'data_labeling', 1.60, 20, 220, 'active'
  ),
  (
    'Nigerian Slang Dictionary',
    'Contribute 30 Nigerian slang words with clear definitions and usage examples. Native speakers are preferred.',
    'data_labeling', 1.50, 18, 300, 'active'
  ),
  (
    'Street Sign Transcription',
    'Transcribe text visible on street signs in 60 provided images taken from across Nigeria.',
    'data_labeling', 1.20, 16, 280, 'active'
  ),
  (
    'Voice Recording — Phrases',
    'Record yourself reading 40 short English phrases clearly. Used to train voice AI models. Microphone required.',
    'data_labeling', 2.50, 20, 200, 'active'
  ),
  (
    'Duplicate Product Detection',
    'Compare pairs of product listings and mark whether they are the same product or different. 50 pairs total.',
    'data_labeling', 1.00, 14, 350, 'active'
  ),
  (
    'Handwriting Transcription',
    'Transcribe handwritten text visible in 20 scanned form images. Only clear handwriting is assigned to this task.',
    'data_labeling', 2.20, 22, 160, 'active'
  ),
  (
    'Logo Brand Recognition',
    'Identify the brand name from 80 partially obscured logo images. Brand knowledge is helpful but not required.',
    'data_labeling', 1.00, 12, 400, 'active'
  )

) AS v(title, description, category, payout_usd, estimated_mins, slots_total, status)
WHERE NOT EXISTS (
  SELECT 1 FROM public.tasks t WHERE t.title = v.title
);

-- ── 3. VERIFY ─────────────────────────────────────────────
SELECT category, COUNT(*) AS task_count, ROUND(AVG(payout_usd),2) AS avg_payout
FROM public.tasks
WHERE status = 'active'
GROUP BY category
ORDER BY category;
