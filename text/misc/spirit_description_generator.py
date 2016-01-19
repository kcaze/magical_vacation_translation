# Useful for dialogue boxes 731 to 746.
spirits = ["Toasty", "Gusty", "Gloomy", "Pretty", "Edgy", "Catchy", "Rocky", "Ansty", "Sticky", "Furry", "Rainy", "Zappy", "Early"]
types = ["fire", "wind", "poison", "beauty", "blade", "sound", "stone", "bug", "wood", "beast", "water", "electric", "ancient"]

template_string = """
If you become friends with the $red$*T1* spirit *S1*$black$, then during battle you can use $blue$Call *S1*$black$ to summon $red$*S1*$black$. If you summon $red$*S1*$black$, the power of *T1* magic is doubled. With two $red$*S1*'s$black$, the power is 4 times as strong, with three 8 times, and it continues to double. $red$*S1*$black$ is weak against the $blue$*T0* spirit *S0*$black$. When $blue$*S0*$black$ is present, it weakens *T1* moves. For example, if there are 2 $blue$*S0*'s$black$ and 4 $red$*S1*'s$black$, then when using *T1* magic, 2 of the $red$*S1*'s$black$ will cancel out with 2 of the $blue$*S0*'s$black$, so you will only see the effect of 2 $red$*S1*'s$black$, or 4 times the magic power. Next, $red$*S1*$black$ has the power to negate the power of the $blue$*T2* spirit *S2*$black$. When someone tries to use *T2* magic, the effect of $blue$*S2*$black$ is cancelled out.
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
