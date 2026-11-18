-- جدول تسجيل موافقات المستخدمين
create table if not exists public.user_consents (
    id uuid primary key default gen_random_uuid(),

    user_id uuid not null
        references auth.users(id) on delete cascade,

    terms_version text not null,
    privacy_version text not null,

    accepted_at timestamptz not null default now(),

    unique (user_id, terms_version, privacy_version)
);

-- تفعيل الحماية
alter table public.user_consents enable row level security;

-- المستخدم يستطيع مشاهدة موافقاته فقط
create policy "Users can view their own consents"
on public.user_consents
for select
to authenticated
using (auth.uid() = user_id);

-- منع المستخدم من تعديل أو حذف سجل الموافقة مباشرة
revoke insert, update, delete
on public.user_consents
from authenticated;

grant select
on public.user_consents
to authenticated;

-- تسجيل الموافقة عند إنشاء الحساب
create or replace function public.record_user_consent()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
    if new.raw_user_meta_data->>'accepted_terms' = 'true' then
        insert into public.user_consents (
            user_id,
            terms_version,
            privacy_version
        )
        values (
            new.id,
            coalesce(
                new.raw_user_meta_data->>'terms_version',
                '1.0'
            ),
            coalesce(
                new.raw_user_meta_data->>'privacy_version',
                '1.0'
            )
        )
        on conflict do nothing;
    end if;

    return new;
end;
$$;

-- ربط التسجيل بقاعدة البيانات
drop trigger if exists on_user_consent_created on auth.users;

create trigger on_user_consent_created
after insert on auth.users
for each row
execute function public.record_user_consent();
