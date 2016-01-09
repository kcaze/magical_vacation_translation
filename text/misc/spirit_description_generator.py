# Useful for dialogue boxes 731 to 746.
spirits = ["Toast", "Air", "Boo", "Powder", "Slash", "Humming", "Flint", "Buzz", "Stick", "Grr", "Flow", "Tesla", "Clock"]
types = ["fire", "wind", "poison", "beauty", "blade", "sound", "stone", "bug", "tree", "beast", "water", "electric", "ancient"]

template_string = """
If you become friends with the
\8e*T1* spirit *S1*\8d, then during
battle you can use \8fCall *S1*\8d to
summon the \8e*T1* spirit *S1*\8d. If
you summon \8e*S1*\8d, the power of
*T1* magic is doubled. With two \8e*S1*s\8d,
the power is 4 times as strong, with three
8 times, and it continues to double. The
\8e*T1* spirit *S1*\8d is weak against the
\8f*T0* spirit *S0*\8d. When \8f*S0*\8d
is present, it weakens *T1* moves. For example,
if there are 2 \8f*S0*s\8d and 4 \8e*S1*s\8d,
then when using *T1* magic, 2 of the \8e*S1*s\8d
will cancel out with 2 of the \8f*S0*s\8d, so
you will only see the effect of 2 \8e*S1*s\8d, or
4 times the magic power. Next, the \8e*T1* spirit
*S1*\8d has the power to negate the power of
\8f*T2* spirit *S2*\8d. When someone tries to use
*T2* magic, the effect of \8f*S2*\8d is cancelled
out.
"""

for ii in range(len(spirits)):
    spirit0 = spirits[(ii-1+len(spirits))%len(spirits)]
    spirit1 = spirits[ii]
    spirit2 = spirits[(ii + 1) % len(spirits)]
    type0 = types[(ii-1+len(spirits))%len(spirits)]
    type1 = types[ii]
    type2 = types[(ii + 1) % len(spirits)]
    print(template_string.replace("*S0*", spirit0)
        .replace("*S1*", spirit1)
        .replace("*S2*", spirit2)
        .replace("*T0*", type1  )
        .replace("*T1*", type1)
        .replace("*T2*", type2))
